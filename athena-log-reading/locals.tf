locals {

  account_id                = data.terraform_remote_state.vpc.outputs.vpc_account_id
  common_name               = data.terraform_remote_state.common.outputs.common_name
  environment_name          = var.environment_name
  region                    = var.region
  tags                      = data.terraform_remote_state.common.outputs.tags
  alb_access_logs_s3_bucket = data.terraform_remote_state.common.outputs.alb_access_logs_s3_bucket.bucket


  # Athena
  database_name = "cporacle_accesslogs"

  table_name_alb_access_logs_website = "alb_access_logs_website"
  table_name_alb_access_logs_api     = "alb_access_logs_api"
}