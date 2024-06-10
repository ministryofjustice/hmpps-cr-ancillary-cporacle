locals {

  common_name = data.terraform_remote_state.common.outputs.common_name

  account_id = data.terraform_remote_state.common.outputs.account_id
  region     = var.region

  vpc_id         = data.terraform_remote_state.common.outputs.vpc_id
  vpc_cidr_block = data.terraform_remote_state.common.outputs.vpc_cidr_block

  private_zone_id   = data.terraform_remote_state.common.outputs.private_zone_id   # Z0172977282BF556T2PJT
  private_zone_name = data.terraform_remote_state.common.outputs.private_zone_name # unpaid.work.dev.cr.internal

  tags = data.terraform_remote_state.common.outputs.tags

  private_subnets = data.terraform_remote_state.common.outputs.private_subnets

  db_subnets = data.terraform_remote_state.common.outputs.db_subnets

  ssh_deployer_key = data.terraform_remote_state.common.outputs.ssh_deployer_key

  #bastion_cidr = flatten(data.terraform_remote_state.common.outputs.bastion_cidr)
  bastion_cidr = ["10.161.98.0/28", "10.161.98.16/28", "10.161.98.32/28"]

  s3_artifact_bucket = data.terraform_remote_state.common.outputs.cporacle_artifacts_s3_bucket.bucket

}