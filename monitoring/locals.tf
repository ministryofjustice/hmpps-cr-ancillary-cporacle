locals {

  # Slack alarms
  slack_nonprod_url     = "/services/???"
  slack_nonprod_channel = "ancilliary-alerts-cporacle-nonprod"

  slack_prod_url        = "/services/???"
  slack_prod_channel    = "ancilliary-alerts-cporacle-production"

  # lambda slack alerting
  lambda_name_alarm          = "${var.environment_name}-notify-cporacle-slack-channel-alarm"
  lambda_alarm_enabled       = true
  lambda_alarm_slack_channel = var.environment_name == "cr-unpaid-work-prod" ? local.slack_prod_channel: local.slack_nonprod_channel
  quiet_period_start_hour    = "0"
  quiet_period_end_hour      = "6"

  

  # metrics  
  cporacle_web_cloudwatch_agent_log_sum_metric_name  = "CPOracleWebCloudwatchAgentErrorLogEventSum"
  cporacle_api_cloudwatch_agent_log_sum_metric_name  = "CPOracleAPICloudwatchAgentErrorLogEventSum"
  
  # Log groups
  cporacle_log_group_application_events = data.terraform_remote_state.ec2.outputs.cporacle_log_group_application_events["name"]
  cporacle_log_group_cloudwatch_agent = data.terraform_remote_state.ec2.outputs.cporacle_log_group_cloudwatch_agent["name"]
  cporacle_log_group_cporacle_application = data.terraform_remote_state.ec2.outputs.cporacle_log_group_cporacle_application["name"]
  cporacle_log_group_system_events = data.terraform_remote_state.ec2.outputs.cporacle_log_group_system_events["name"]

  cporacle_log_group_application_events_api = data.terraform_remote_state.ec2.outputs.cporacle_log_group_application_events_api["name"]
  cporacle_log_group_cloudwatch_agent_api = data.terraform_remote_state.ec2.outputs.cporacle_log_group_cloudwatch_agent_api["name"]
  cporacle_log_group_cporacle_api = data.terraform_remote_state.ec2.outputs.cporacle_log_group_cporacle_api["name"]
  cporacle_log_group_system_events_api = data.terraform_remote_state.ec2.outputs.cporacle_log_group_system_events_api["name"]



  tags = var.tags

  environment_name = var.environment_name
  
  cporacle_account_ids = {
    cr-unpaid-work-dev  = "964150688482"
    cr-unpaid-work-prod = "787475932003"
  }

  
}
