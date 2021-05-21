locals {

  #------------------------------------
  # Common
  #------------------------------------
  common_name = data.terraform_remote_state.cporacle_common.outputs.common_name

  environment_name = var.environment_name

  account_id = data.terraform_remote_state.core_vpc.outputs.vpc_account_id
  region     = var.region

  vpc_id         = data.terraform_remote_state.core_vpc.outputs.vpc_id
  vpc_cidr_block = data.terraform_remote_state.core_vpc.outputs.vpc_cidr_block

  private_zone_id   = data.terraform_remote_state.core_vpc.outputs.private_zone_id   # Z0172977282BF556T2PJT
  private_zone_name = data.terraform_remote_state.core_vpc.outputs.private_zone_name # unpaid.work.dev.cr.internal
  
  strategic_public_zone_id   = data.terraform_remote_state.core_vpc.outputs.strategic_public_zone_id   # 
  strategic_public_zone_name = data.terraform_remote_state.core_vpc.outputs.strategic_public_zone_name # 
  
  tags = data.terraform_remote_state.cporacle_common.outputs.tags

  private_subnets = [data.terraform_remote_state.core_vpc.outputs.vpc_private-subnet-az1,
    data.terraform_remote_state.core_vpc.outputs.vpc_private-subnet-az2,
    data.terraform_remote_state.core_vpc.outputs.vpc_private-subnet-az3
  ]

  ec2_instance_profile = data.terraform_remote_state.cporacle_iam.outputs.iam_instance_profile_cp_oracle.iam_instance_name
  
  ec2_props = {
    ami_id                = "ami-07c04e88f232dc18a"
    ami_image_tag_version = "0.61.0"
    instance_type         = "t3.2xlarge"
    ebs_volume_size       = 120
  }

  asg_security_groups = [data.terraform_remote_state.cporacle_security_groups.outputs.cporacle_appservers.id]

  ssh_deployer_key = data.terraform_remote_state.core_vpc.outputs.ssh_deployer_key

  admin_server_count = 2
  admin_instance_type = "t2.large"
  admin_instance_ami  = "ami-02a6373a5071b0b49" # HMPPS MIS NART ADM Windows Server master 1615546824 (0.46.0)

  admin_root_size     = 60
  hostname            = "${local.environment_name}-admin"
  
}