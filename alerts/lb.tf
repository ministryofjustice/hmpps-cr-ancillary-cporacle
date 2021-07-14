# LB instance health check - API
resource "aws_cloudwatch_metric_alarm" "API_lb_healthy_hosts_less_than_one" {
  alarm_name          = "${var.environment_name}_CPOracle_API_lb_unhealthy_hosts_count--critical"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "No Healthy Hosts!!! CPOracle API is down"
  alarm_actions       = [local.sns_alarm_notification_arn]
  ok_actions          = [local.sns_alarm_notification_arn]

  dimensions = {
    TargetGroup  = local.cporacle_api_tg["arn_suffix"]
    LoadBalancer = local.cporacle_api_alb["arn_suffix"]
  }

  tags = local.tags
}

# LB instance health check - APP
resource "aws_cloudwatch_metric_alarm" "APP_lb_healthy_hosts_less_than_one" {
  alarm_name          = "${var.environment_name}_CPOracle_APP_lb_unhealthy_hosts_count--critical"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "No Healthy Hosts!!! CPOracle APP is down"
  alarm_actions       = [local.sns_alarm_notification_arn]
  ok_actions          = [local.sns_alarm_notification_arn]

  dimensions = {
    TargetGroup  = local.cporacle_app_tg["arn_suffix"]
    LoadBalancer = local.cporacle_app_alb["arn_suffix"]
  }

  tags = local.tags
}
