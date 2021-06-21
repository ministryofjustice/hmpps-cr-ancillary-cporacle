resource "aws_cloudwatch_log_metric_filter" "cporacle_web_cloudwatch_agent_log_count" {
  name           = local.cporacle_web_cloudwatch_agent_log_sum_metric_name
  pattern        = ""
  log_group_name = local.cporacle_log_group_cloudwatch_agent

  metric_transformation {
    name          = local.cporacle_log_group_cloudwatch_agent
    namespace     = "cporacle_web"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_metric_alarm" "cporacle_web_cloudwatch_agent_log_warning" {
  alarm_name                = "${var.environment_name}-cporacle_web-cloudwatch_agent_log--warning"
  comparison_operator       = "LessThanThreshold"
  period                    = "60"
  evaluation_periods        = "5"
  metric_name               = local.cporacle_web_cloudwatch_agent_log_sum_metric_name
  namespace                 = "cporacle_web"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_actions             = [local.sns_alarm_notification_arn]
  ok_actions                = [local.sns_alarm_notification_arn]
  alarm_description         = "No cloudwatch agent logs for 5 minutes"
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  tags                      = local.tags
}

resource "aws_cloudwatch_metric_alarm" "cporacle_web_cloudwatch_agent_log_critical" {
  alarm_name                = "${var.environment_name}-cporacle_web-cloudwatch_agent_log--critical"
  comparison_operator       = "LessThanThreshold"
  period                    = "60"
  evaluation_periods        = "15"
  metric_name               = local.cporacle_web_cloudwatch_agent_log_sum_metric_name
  namespace                 = "cporacle_web"
  statistic                 = "Sum"
  threshold                 = "3"
  alarm_actions             = [local.sns_alarm_notification_arn]
  ok_actions                = [local.sns_alarm_notification_arn]
  alarm_description         = "No cloudwatch agent logs for 15 minutes"
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  tags                      = local.tags
}

