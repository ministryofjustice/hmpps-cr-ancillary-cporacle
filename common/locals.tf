locals {

  common_name = "cp-oracle"
  account_id       = data.terraform_remote_state.vpc.outputs.vpc_account_id
  region           = var.region

  vpc_id         = data.terraform_remote_state.vpc.outputs.vpc_id
  vpc_cidr_block = data.terraform_remote_state.vpc.outputs.vpc_cidr_block

  private_zone_id   = data.terraform_remote_state.vpc.outputs.private_zone_id   # Z0172977282BF556T2PJT
  private_zone_name = data.terraform_remote_state.vpc.outputs.private_zone_name # unpaid.work.dev.cr.internal

  tags = merge(
    data.terraform_remote_state.vpc.outputs.tags,
    {
      "application" = "cp-oracle"
    },
    { 
      "source-code" = "https://github.com/ministryofjustice/hmpps-cr-ancillary-cporacle" 
    }  
  )

  private_subnets = [
    data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az1,
    data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az2,
    data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az3
  ]

  db_subnets = [
    data.terraform_remote_state.vpc.outputs.vpc_db-subnet-az1,
    data.terraform_remote_state.vpc.outputs.vpc_db-subnet-az2,
    data.terraform_remote_state.vpc.outputs.vpc_db-subnet-az3
  ]

  ssh_deployer_key = data.terraform_remote_state.vpc.outputs.ssh_deployer_key

}