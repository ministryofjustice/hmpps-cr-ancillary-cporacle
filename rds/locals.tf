locals {

  common_name = data.terraform_remote_state.cporacle_common.outputs.common_name
  environment_name = var.environment_name
  account_id                   = data.terraform_remote_state.vpc.outputs.vpc_account_id
  region                       = var.region
  
  vpc_id                       = data.terraform_remote_state.vpc.outputs.vpc_id
  vpc_cidr_block                   = data.terraform_remote_state.vpc.outputs.vpc_cidr_block
  
  private_zone_id              = data.terraform_remote_state.vpc.outputs.private_zone_id     # Z0172977282BF556T2PJT
  private_zone_name            = data.terraform_remote_state.vpc.outputs.private_zone_name   # unpaid.work.dev.cr.internal
  
  tags = data.terraform_remote_state.cporacle_common.outputs.tags
  
  private_subnets              = [ data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az1,
                                   data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az2,
                                   data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az3
  ]

  db_subnets                   = [ data.terraform_remote_state.vpc.outputs.vpc_db-subnet-az1,
                                   data.terraform_remote_state.vpc.outputs.vpc_db-subnet-az2,
                                   data.terraform_remote_state.vpc.outputs.vpc_db-subnet-az3
  ]
  
  ssh_deployer_key             = data.terraform_remote_state.vpc.outputs.ssh_deployer_key
  
  
  family               = var.rds_family
  major_engine_version = var.rds_major_engine_version
  engine               = var.rds_engine
  engine_version       = var.rds_engine_version
  instance_class       = var.rds_instance_class
  allocated_storage    = var.rds_allocated_storage
  character_set_name   = var.rds_character_set_name
  enabled_cloudwatch_logs_exports = ["agent", "error"]
  multi_az = var.multi_az
  options = var.options



}