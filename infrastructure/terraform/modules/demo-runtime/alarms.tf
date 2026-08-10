resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  count = var.enable_deployment_alarms ? 1 : 0

  alarm_name = "${local.prefix}-demo-alb-5xx"

  alarm_description = "CloudForge ALB tarafında artan 5xx hatalarını izler."

  namespace   = "AWS/ApplicationELB"
  metric_name = "HTTPCode_ELB_5XX_Count"

  dimensions = {
    LoadBalancer = aws_lb.demo.arn_suffix
  }

  statistic = "Sum"
  period    = 60

  evaluation_periods  = 2
  datapoints_to_alarm = 2

  threshold           = var.deployment_5xx_threshold
  comparison_operator = "GreaterThanOrEqualToThreshold"

  treat_missing_data = "notBreaching"

  tags = local.tags
}

resource "aws_cloudwatch_metric_alarm" "target_5xx_primary" {
  count = var.enable_deployment_alarms ? 1 : 0

  alarm_name = "${local.prefix}-demo-primary-5xx"

  alarm_description = "Primary ECS target group uygulama 5xx hatalarını izler."

  namespace   = "AWS/ApplicationELB"
  metric_name = "HTTPCode_Target_5XX_Count"

  dimensions = {
    LoadBalancer = aws_lb.demo.arn_suffix
    TargetGroup  = aws_lb_target_group.demo.arn_suffix
  }

  statistic = "Sum"
  period    = 60

  evaluation_periods  = 2
  datapoints_to_alarm = 2

  threshold           = var.deployment_5xx_threshold
  comparison_operator = "GreaterThanOrEqualToThreshold"

  treat_missing_data = "notBreaching"

  tags = local.tags
}

resource "aws_cloudwatch_metric_alarm" "target_5xx_alternate" {
  count = (
    var.enable_deployment_alarms
    && var.deployment_strategy == "BLUE_GREEN"
  ) ? 1 : 0

  alarm_name = "${local.prefix}-demo-alternate-5xx"

  alarm_description = "Alternate ECS target group uygulama 5xx hatalarını izler."

  namespace   = "AWS/ApplicationELB"
  metric_name = "HTTPCode_Target_5XX_Count"

  dimensions = {
    LoadBalancer = aws_lb.demo.arn_suffix
    TargetGroup  = aws_lb_target_group.demo_alternate[0].arn_suffix
  }

  statistic = "Sum"
  period    = 60

  evaluation_periods  = 2
  datapoints_to_alarm = 2

  threshold           = var.deployment_5xx_threshold
  comparison_operator = "GreaterThanOrEqualToThreshold"

  treat_missing_data = "notBreaching"

  tags = local.tags
}
