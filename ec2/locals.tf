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

  # public_zone_id    = data.terraform_remote_state.core_vpc.outputs.public_zone_id     # Z00582952AVV2DR3TYHKC
  # public_zone_name  = data.terraform_remote_state.core_vpc.outputs.public_zone_name   # unpaid.work.dev.cr.probation.service.justice.gov.uk
  # public_ssl_arn    = data.terraform_remote_state.core_vpc.outputs.public_ssl_arn     # 
  # public_ssl_domain = data.terraform_remote_state.core_vpc.outputs.public_ssl_domain  # 

  strategic_public_zone_id   = data.terraform_remote_state.core_vpc.outputs.strategic_public_zone_id   # 
  strategic_public_zone_name = data.terraform_remote_state.core_vpc.outputs.strategic_public_zone_name # 
  # strategic_public_ssl_arn   = data.terraform_remote_state.core_vpc.outputs.strategic_public_ssl_arn   # 

  tags = data.terraform_remote_state.cporacle_common.outputs.tags

  private_subnets = [data.terraform_remote_state.core_vpc.outputs.vpc_private-subnet-az1,
    data.terraform_remote_state.core_vpc.outputs.vpc_private-subnet-az2,
    data.terraform_remote_state.core_vpc.outputs.vpc_private-subnet-az3
  ]

  db_subnets = [data.terraform_remote_state.core_vpc.outputs.vpc_db-subnet-az1,
    data.terraform_remote_state.core_vpc.outputs.vpc_db-subnet-az2,
    data.terraform_remote_state.core_vpc.outputs.vpc_db-subnet-az3
  ]

  #------------------------------------
  # ALB
  #------------------------------------
  # alb_name            = "${local.common_name}-lb"
  # alb_path            = "/"
  # alb_subnets         = local.private_subnets
  # alb_security_groups = [data.terraform_remote_state.cporacle_security_groups.outputs.cporacle_lb.id]
  # internal_alb        = true
  # idle_timeout        = 60
  # elb_logs_s3_bucket  = "${local.common_name}-lb-s3-bucket" # create bucket and reference

  #------------------------------------
  # ALB Listener
  #------------------------------------
  # alb_listener_port            = 443
  # alb_listener_protocol        = "HTTPS"
  # alb_listener_ssl_policy      = "ELBSecurityPolicy-2016-08"
  # alb_listener_certificate_arn = data.terraform_remote_state.core_vpc.outputs.strategic_public_ssl_arn[0]
  # # priority = ""

  # #------------------------------------
  # # Target Group
  # #------------------------------------
  #target_group_name   = "${local.common_name}-app-asg-target-group"
  #target_group_sticky = false
  #web_target_group_arn = data.terraform_remote_state.alb.outputs.alb_target_group_web["arn"]
  #api_target_group_arn = data.terraform_remote_state.alb.outputs.alb_target_group_api["arn"]
  # health_check_target_group_path = "/"

  # target_group_port = 80
  # svc_port = 80

  #------------------------------------
  #ASG - Website
  #------------------------------------
  asg_name             = "${local.common_name}-app"
  launch_template_name = "${local.common_name}-app"

  #------------------------------------
  #ASG - Web API
  #------------------------------------
  asg_api_name             = "${local.common_name}-api"
  launch_template_api_name = "${local.common_name}-api"

  # website ASG instance properties
  cporacle_asg_props = var.cporacle_asg_props
  # web api ASG instance properties
  cporacle_api_asg_props = var.cporacle_api_asg_props

  ec2_instance_profile = data.terraform_remote_state.cporacle_iam.outputs.iam_instance_profile_cp_oracle
  asg_security_groups  = [data.terraform_remote_state.cporacle_security_groups.outputs.cporacle_appservers.id]
  ssh_deployer_key     = data.terraform_remote_state.core_vpc.outputs.ssh_deployer_key
}