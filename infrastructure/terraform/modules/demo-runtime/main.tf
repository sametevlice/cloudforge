locals {
  prefix        = "${var.project_name}-${var.environment}"
  container     = "demo-app"
  image_uri     = "${var.ecr_repository_url}:${var.image_tag}"
  db_secret_arn = aws_db_instance.demo.master_user_secret[0].secret_arn
  db_url        = "jdbc:postgresql://${aws_db_instance.demo.address}:${aws_db_instance.demo.port}/${var.database_name}"

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_ecs_cluster" "this" {
  name = "${local.prefix}-cluster"
  tags = local.tags
}

resource "aws_cloudwatch_log_group" "demo" {
  name              = "/cloudforge/${var.environment}/demo-app"
  retention_in_days = 7
  tags              = local.tags
}

resource "aws_db_subnet_group" "demo" {
  name       = "${local.prefix}-demo-db"
  subnet_ids = var.private_data_subnet_ids
  tags       = local.tags
}

resource "aws_db_instance" "demo" {
  identifier = "${local.prefix}-demo-postgres"

  engine         = "postgres"
  instance_class = var.database_instance_class

  allocated_storage     = 20
  max_allocated_storage = 40
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.database_name
  username = var.database_username
  port     = 5432

  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.demo.name
  vpc_security_group_ids = [var.rds_security_group_id]
  publicly_accessible    = false
  multi_az               = false

  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false
  apply_immediately       = true

  tags = local.tags
}

resource "aws_lb" "demo" {
  name               = "${local.prefix}-demo-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids
  tags               = local.tags
}

resource "aws_lb_target_group" "demo" {
  name        = "${local.prefix}-demo-tg"
  port        = var.application_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  deregistration_delay = 30

  health_check {
    enabled             = true
    path                = "/actuator/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = local.tags
}

resource "aws_lb_target_group" "demo_alternate" {
  count = var.deployment_strategy == "BLUE_GREEN" ? 1 : 0

  name = substr(
    "${local.prefix}-demo-alt",
    0,
    32
  )

  port        = var.application_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  deregistration_delay = 30

  health_check {
    enabled             = true
    path                = "/actuator/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = local.tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.demo.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.demo.arn
  }
}

resource "aws_lb_listener_rule" "production" {
  count = var.deployment_strategy == "BLUE_GREEN" ? 1 : 0

  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.demo.arn
        weight = 1
      }

      target_group {
        arn    = aws_lb_target_group.demo_alternate[0].arn
        weight = 0
      }
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  lifecycle {
    ignore_changes = [
      action
    ]
  }
}

data "aws_iam_policy_document" "ecs_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "execution" {
  name               = "${local.prefix}-demo-execution"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume.json
}

resource "aws_iam_role_policy_attachment" "execution" {
  role       = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "secret_read" {
  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [local.db_secret_arn]
  }
}

resource "aws_iam_role_policy" "secret_read" {
  name   = "${local.prefix}-demo-secret-read"
  role   = aws_iam_role.execution.id
  policy = data.aws_iam_policy_document.secret_read.json
}

resource "aws_iam_role" "task" {
  name               = "${local.prefix}-demo-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume.json
}

resource "aws_ecs_task_definition" "demo" {
  count = var.deploy_service ? 1 : 0

  family                   = "${local.prefix}-demo-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = tostring(var.application_cpu)
  memory                   = tostring(var.application_memory)
  execution_role_arn       = aws_iam_role.execution.arn
  task_role_arn            = aws_iam_role.task.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([{
    name      = local.container
    image     = local.image_uri
    essential = true

    portMappings = [{
      containerPort = var.application_port
      hostPort      = var.application_port
      protocol      = "tcp"
    }]

    environment = [
      { name = "DATABASE_URL", value = local.db_url },
      { name = "DATABASE_USERNAME", value = var.database_username },
      { name = "APP_VERSION", value = var.image_tag },
      { name = "GIT_COMMIT", value = var.image_tag }
    ]

    secrets = [{
      name      = "DATABASE_PASSWORD"
      valueFrom = "${local.db_secret_arn}:password::"
    }]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.demo.name
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "ecs"
      }
    }

    healthCheck = {
      command     = ["CMD-SHELL", "curl --fail --silent http://localhost:${var.application_port}/actuator/health || exit 1"]
      interval    = 30
      timeout     = 5
      retries     = 3
      startPeriod = 60
    }
  }])

  tags = local.tags
}

resource "aws_ecs_service" "demo" {
  count = var.deploy_service ? 1 : 0

  name             = "${local.prefix}-demo-app"
  cluster          = aws_ecs_cluster.this.id
  task_definition  = aws_ecs_task_definition.demo[0].arn
  desired_count    = var.desired_count
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  deployment_controller {
    type = "ECS"
  }

  deployment_configuration {
    strategy = var.deployment_strategy

    bake_time_in_minutes = (
      var.deployment_strategy == "BLUE_GREEN"
      ? var.deployment_bake_time_minutes
      : null
    )
  }

  dynamic "alarms" {
    for_each = var.enable_deployment_alarms ? [1] : []

    content {
      enable   = true
      rollback = true

      alarm_names = concat(
        [
          aws_cloudwatch_metric_alarm.alb_5xx[0].alarm_name,
          aws_cloudwatch_metric_alarm.target_5xx_primary[0].alarm_name
        ],
        var.deployment_strategy == "BLUE_GREEN"
        ? [
          aws_cloudwatch_metric_alarm.target_5xx_alternate[0].alarm_name
        ]
        : []
      )
    }
  }

  dynamic "deployment_circuit_breaker" {
    for_each = var.deployment_strategy == "ROLLING" ? [1] : []

    content {
      enable   = true
      rollback = true
    }
  }

  health_check_grace_period_seconds = 90

  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [var.ecs_security_group_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.demo.arn
    container_name   = local.container
    container_port   = var.application_port

    dynamic "advanced_configuration" {
      for_each = var.deployment_strategy == "BLUE_GREEN" ? [1] : []

      content {
        alternate_target_group_arn = aws_lb_target_group.demo_alternate[0].arn

        production_listener_rule = aws_lb_listener_rule.production[0].arn

        role_arn = aws_iam_role.ecs_infrastructure[0].arn
      }
    }
  }

  wait_for_steady_state = true

  depends_on = [
    aws_lb_listener.http,
    aws_lb_listener_rule.production,
    aws_iam_role_policy_attachment.execution,
    aws_iam_role_policy.secret_read,
    aws_iam_role_policy_attachment.ecs_infrastructure
  ]

  lifecycle {
    ignore_changes = [
      task_definition,
      desired_count
    ]
  }

  tags = local.tags

}

data "aws_iam_policy_document" "ecs_infrastructure_assume" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"

      identifiers = [
        "ecs.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "ecs_infrastructure" {
  count = var.deployment_strategy == "BLUE_GREEN" ? 1 : 0

  name = "${local.prefix}-ecs-infrastructure"

  assume_role_policy = data.aws_iam_policy_document.ecs_infrastructure_assume.json

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "ecs_infrastructure" {
  count = var.deployment_strategy == "BLUE_GREEN" ? 1 : 0

  role = aws_iam_role.ecs_infrastructure[0].name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSInfrastructureRolePolicyForLoadBalancers"
}
