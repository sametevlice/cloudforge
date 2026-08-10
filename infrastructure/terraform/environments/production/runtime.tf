module "demo_runtime" {
  count = var.enable_runtime_foundation ? 1 : 0

  source = "../../modules/demo-runtime"

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region

  vpc_id = module.vpc.vpc_id

  public_subnet_ids = module.vpc.public_subnet_ids

  private_data_subnet_ids = module.vpc.private_data_subnet_ids

  alb_security_group_id = module.vpc.alb_security_group_id
  ecs_security_group_id = module.vpc.ecs_security_group_id
  rds_security_group_id = module.vpc.rds_security_group_id

  ecr_repository_url = data.aws_ecr_repository.demo.repository_url

  image_tag      = var.demo_image_tag
  deploy_service = var.deploy_demo_service

  application_port   = var.application_port
  application_cpu    = var.demo_application_cpu
  application_memory = var.demo_application_memory
  desired_count      = var.demo_desired_count

  database_name           = var.demo_database_name
  database_username       = var.demo_database_username
  database_instance_class = var.demo_database_instance_class

  deployment_strategy = "BLUE_GREEN"

  deployment_bake_time_minutes = var.deployment_bake_time_minutes
  enable_deployment_alarms     = true

  deployment_5xx_threshold = 5

  enable_autoscaling = true

  autoscaling_min_capacity = 1
  autoscaling_max_capacity = 4

  autoscaling_cpu_target    = 60
  autoscaling_memory_target = 70

}
