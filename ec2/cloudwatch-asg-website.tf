
resource "aws_cloudwatch_log_group" "cporacle_log_group_cloudwatch_agent" {
  name              = "${var.environment_name}/cporacle/amazon-cloudwatch-agent.log"
  retention_in_days = var.log_retention
  tags = merge(
    local.tags,
    {
      "Name" = "${var.environment_name}/cporacle/amazon-cloudwatch-agent.log"
    },
  )
}

resource "aws_cloudwatch_log_group" "cporacle_log_group_cporacle_application" {
  name              = "${var.environment_name}/cporacle/application_logs.log"
  retention_in_days = var.log_retention
  tags = merge(
    local.tags,
    {
      "Name" = "${var.environment_name}/cporacle/application_logs.log"
    },
  )
}

resource "aws_cloudwatch_log_group" "cporacle_log_group_system_events" {
  name              = "${var.environment_name}/cporacle/system-events"
  retention_in_days = var.log_retention
  tags = merge(
    local.tags,
    {
      "Name" = "${var.environment_name}/cporacle/system-events"
    },
  )
}


resource "aws_cloudwatch_log_group" "cporacle_log_group_application_events" {
  name              = "${var.environment_name}/cporacle/application-events"
  retention_in_days = var.log_retention
  tags = merge(
    local.tags,
    {
      "Name" = "${var.environment_name}/cporacle/application-events"
    },
  )
}