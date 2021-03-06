# CPU Utilization - Critical
resource "aws_cloudwatch_metric_alarm" "API_CPUUtilization_critical" {
  alarm_name          = "${var.environment_name}_CPOracle_API_Instance_CPUUtilization--critical"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "CPU Utilization for the CPOracle API instance is greater than 80%"
  alarm_actions       = [local.sns_alarm_notification_arn]
  ok_actions          = [local.sns_alarm_notification_arn]

  dimensions = {
    AutoScalingGroupName = local.cporacle_api_asg
  }

  tags = local.tags
}

# CPU Utilization - Warning
resource "aws_cloudwatch_metric_alarm" "API_CPUUtilization_warning" {
  alarm_name          = "${var.environment_name}_CPOracle_API_Instance_CPUUtilization--warning"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 60
  alarm_description   = "CPU Utilization for the CPOracle API instance is greater than 60%"
  alarm_actions       = [local.sns_alarm_notification_arn]
  ok_actions          = [local.sns_alarm_notification_arn]

  dimensions = {
    AutoScalingGroupName = local.cporacle_api_asg
  }

  tags = local.tags
}

# Instance Status Failed - Critical
resource "aws_cloudwatch_metric_alarm" "API_StatusCheckFailed" {
  alarm_name          = "${var.environment_name}_CPOracle_API_Instance_StatusCheckFailed--critical"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "ec2 StatusCheckFailed for CPOracle API instance"
  alarm_actions       = [local.sns_alarm_notification_arn]
  ok_actions          = [local.sns_alarm_notification_arn]

  dimensions = {
    AutoScalingGroupName = local.cporacle_api_asg
  }

  tags = local.tags
}

# Memory Utilization - Critical
resource "aws_cloudwatch_metric_alarm" "API_MemoryUtilization_critical" {
  alarm_name          = "${var.environment_name}_CPOracle_API_Instance_MemoryUtilization--critical"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "MemoryUtilization"
  namespace           = "CWAgent"
  period              = 120
  statistic           = "Average"
  threshold           = 85
  alarm_description   = "Memory Utilization is averaging 85% for CPOracle API Instance."
  alarm_actions       = [local.sns_alarm_notification_arn]
  ok_actions          = [local.sns_alarm_notification_arn]

  dimensions = {
    AutoScalingGroupName = local.cporacle_api_asg
    objectname           = "Memory"
  }

  tags = local.tags
}

# Memory Utilization - Warning
resource "aws_cloudwatch_metric_alarm" "API_MemoryUtilization_warning" {
  alarm_name          = "${var.environment_name}_CPOracle_API_Instance_MemoryUtilization--warning"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "MemoryUtilization"
  namespace           = "CWAgent"
  period              = 120
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Memory Utilization is averaging 70% for CPOracle API Instance."
  alarm_actions       = [local.sns_alarm_notification_arn]
  ok_actions          = [local.sns_alarm_notification_arn]

  dimensions = {
    AutoScalingGroupName = local.cporacle_api_asg
    objectname           = "Memory"
  }

  tags = local.tags
}

#  Drive Space - Critical
resource "aws_cloudwatch_metric_alarm" "API_free_disk_space_C_critical" {
  alarm_name          = "${var.environment_name}_CPOracle_API_Instance_Free_Space_C_Drive--critical"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "LogicalDisk % Free Space"
  namespace           = "CWAgent"
  period              = 60
  statistic           = "Average"
  threshold           = 5
  alarm_description   = "C: Drive Free Space is less than 5% on CPOracle API Instance."
  alarm_actions       = [local.sns_alarm_notification_arn]
  ok_actions          = [local.sns_alarm_notification_arn]

  dimensions = {
    instance             = "C:"
    AutoScalingGroupName = local.cporacle_api_asg
    objectname           = "LogicalDisk"
  }

  tags = local.tags
}

#  Drive Space - Warning
resource "aws_cloudwatch_metric_alarm" "API_free_disk_space_C_warning" {
  alarm_name          = "${var.environment_name}_CPOracle_API_Instance_Free_Space_C_Drive--warning"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "LogicalDisk % Free Space"
  namespace           = "CWAgent"
  period              = 60
  statistic           = "Average"
  threshold           = 25
  alarm_description   = "C: Drive Free Space is less than 25% on CPOracle API Instance."
  alarm_actions       = [local.sns_alarm_notification_arn]
  ok_actions          = [local.sns_alarm_notification_arn]

  dimensions = {
    instance             = "C:"
    AutoScalingGroupName = local.cporacle_api_asg
    objectname           = "LogicalDisk"
  }

  tags = local.tags
}
