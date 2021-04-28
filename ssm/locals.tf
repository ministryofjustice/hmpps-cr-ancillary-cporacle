locals {

  common_name = data.terraform_remote_state.common.outputs.common_name

  account_id = data.terraform_remote_state.common.outputs.account_id
  region     = var.region

  tags = data.terraform_remote_state.common.outputs.tags

  RDSUsername = "cporacle_app"
}