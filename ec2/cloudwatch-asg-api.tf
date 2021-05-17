
resource "aws_cloudwatch_log_group" "cporacle_log_group_cloudwatch_agent_api" {
  name              = "${var.environment_name}/cporacle_api/amazon-cloudwatch-agent.log" 
  retention_in_days = var.log_retention
  tags = merge(
    local.tags,
    {
      "Name" = "${var.environment_name}/cporacle_api/amazon-cloudwatch-agent.log"
    },
  )
}

resource "aws_cloudwatch_log_group" "cporacle_log_group_cporacle_api" {
  name              = "${var.environment_name}/cporacle_api/api_logs.log" 
  retention_in_days = var.log_retention
  tags = merge(
    local.tags,
    {
      "Name" = "${var.environment_name}/cporacle_api/api_logs.log" 
    },
  )
}

resource "aws_cloudwatch_log_group" "cporacle_log_group_system_events_api" {
  name              = "${var.environment_name}/cporacle_api/system-events_api" 
  retention_in_days = var.log_retention
  tags = merge(
    local.tags,
    {
      "Name" = "${var.environment_name}/cporacle_api/system-events_api"
    },
  )
}


resource "aws_cloudwatch_log_group" "cporacle_log_group_application_events_api" {
  name              = "${var.environment_name}/cporacle_api/application-events_api" 
  retention_in_days = var.log_retention
  tags = merge(
    local.tags,
    {
      "Name" = "${var.environment_name}/cporacle_api/application-events_api"
    },
  )
}