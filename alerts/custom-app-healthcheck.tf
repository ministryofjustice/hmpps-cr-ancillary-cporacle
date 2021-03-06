# IIS HttpErr log Metrics
resource "aws_cloudwatch_log_metric_filter" "APP_iis_httperr_metrics" {
  name           = "${var.environment_name}_APP_IIS_AppPool"
  pattern        = "AppOffline"
  log_group_name = local.app_log_group_name

  metric_transformation {
    name          = "${var.environment_name}_APP_AppPool"
    namespace     = "IIS"
    value         = 1
    default_value = 0
  }
}

# IIS HttpErr Alarm
resource "aws_cloudwatch_metric_alarm" "APP_iis_httperr" {
  alarm_name          = "${var.environment_name}_APP_AppPool_Offline--critical"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "${var.environment_name}_APP_AppPool"
  namespace           = "IIS"
  period              = "60"
  statistic           = "Average"
  threshold           = "0"
  alarm_description   = "This metric monitors IIS HttpErr of APP"
  alarm_actions       = [local.sns_alarm_notification_arn]
  ok_actions          = [local.sns_alarm_notification_arn]
  tags                = local.tags
}

# Endpoint HealthCheck using Route53
# London Region not support yet, so metrics are not yet publised, can be enabled at later stage
resource "aws_route53_health_check" "APP_cporacle" {
  fqdn              = local.app_aws_route53_record_name
  port              = 443
  type              = "HTTPS"
  resource_path     = "/karma.html"
  failure_threshold = 3
  request_interval  = 30
  regions           = ["us-east-1", "eu-west-1", "ap-southeast-1"]
  tags              = local.tags
}

# London Region not support yet, so metrics are not yet publised, can be enabled at later stage
/* 
resource "aws_cloudwatch_metric_alarm" "APP_cporacle" {
  alarm_name          = "${var.environment_name}_APP_endpoint_status--critical"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "1"
  alarm_description   = "Route53 health check status for ${local.APP_cporacle["aws_route53_record_name"]}"
  alarm_actions       = [local.sns_alarm_notification_arn]
  ok_actions          = [local.sns_alarm_notification_arn]

  dimensions = {
    HealthCheckId = aws_route53_health_check.APP_cporacle.id
  }

  tags                = local.tags
}
*/
