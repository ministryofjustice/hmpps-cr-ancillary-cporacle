locals {

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

  sns_alarm_notification_arn = data.terraform_remote_state.monitoring.outputs.aws_sns_topic_alarm_notification["arn"]
  db_instance_id             = "${var.environment_name}-native-backup-restore"
  cporacle_api_asg           = data.terraform_remote_state.ec2.outputs.cporacle_app_asg["name"]
  cporacle_app_asg           = data.terraform_remote_state.ec2.outputs.cporacle_app_asg["name"]
  cporacle_api_alb           = data.terraform_remote_state.alb.outputs.alb_api
  cporacle_app_alb           = data.terraform_remote_state.alb.outputs.alb_website
  cporacle_api_tg            = data.terraform_remote_state.alb.outputs.alb_target_group_api
  cporacle_app_tg            = data.terraform_remote_state.alb.outputs.alb_target_group_web
}
