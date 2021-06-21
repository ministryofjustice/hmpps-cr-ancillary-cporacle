locals {
  artifacts_s3_bucket_name              = data.terraform_remote_state.common.outputs.cporacle_artifacts_s3_bucket["id"]
  app_log_group_name                    = data.terraform_remote_state.ec2.outputs.cporacle_log_group_cporacle_application["name"]
  app_system_events_log_group_name      = data.terraform_remote_state.ec2.outputs.cporacle_log_group_system_events["name"]
  app_application_events_log_group_name = data.terraform_remote_state.ec2.outputs.cporacle_log_group_application_events["name"]
  api_log_group_name                    = data.terraform_remote_state.ec2.outputs.cporacle_log_group_cporacle_api["name"]
  api_system_events_log_group_name      = data.terraform_remote_state.ec2.outputs.cporacle_log_group_system_events_api["name"]
  api_application_events_log_group_name = data.terraform_remote_state.ec2.outputs.cporacle_log_group_application_events_api["name"]
}
