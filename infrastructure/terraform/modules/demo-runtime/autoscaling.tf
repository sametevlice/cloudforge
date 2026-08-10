resource "aws_appautoscaling_target" "demo" {
  count = (
    var.deploy_service
    && var.enable_autoscaling
  ) ? 1 : 0

  min_capacity = var.autoscaling_min_capacity
  max_capacity = var.autoscaling_max_capacity

  resource_id = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.demo[0].name}"

  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "cpu" {
  count = (
    var.deploy_service
    && var.enable_autoscaling
  ) ? 1 : 0

  name = "${local.prefix}-demo-cpu-scaling"

  policy_type = "TargetTrackingScaling"

  resource_id        = aws_appautoscaling_target.demo[0].resource_id
  scalable_dimension = aws_appautoscaling_target.demo[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.demo[0].service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = var.autoscaling_cpu_target

    scale_in_cooldown  = 60
    scale_out_cooldown = 60

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

resource "aws_appautoscaling_policy" "memory" {
  count = (
    var.deploy_service
    && var.enable_autoscaling
  ) ? 1 : 0

  name = "${local.prefix}-demo-memory-scaling"

  policy_type = "TargetTrackingScaling"

  resource_id        = aws_appautoscaling_target.demo[0].resource_id
  scalable_dimension = aws_appautoscaling_target.demo[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.demo[0].service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = var.autoscaling_memory_target

    scale_in_cooldown  = 60
    scale_out_cooldown = 60

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
  }
}
