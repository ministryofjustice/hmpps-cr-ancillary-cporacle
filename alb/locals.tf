locals {

  #------------------------------------
  # Common
  #------------------------------------
  common_name = data.terraform_remote_state.common.outputs.common_name

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

  tags = data.terraform_remote_state.common.outputs.tags

  public_subnets = [data.terraform_remote_state.core_vpc.outputs.vpc_public-subnet-az1,
    data.terraform_remote_state.core_vpc.outputs.vpc_public-subnet-az2,
    data.terraform_remote_state.core_vpc.outputs.vpc_public-subnet-az3
  ]

  private_subnets = [data.terraform_remote_state.core_vpc.outputs.vpc_private-subnet-az1,
    data.terraform_remote_state.core_vpc.outputs.vpc_private-subnet-az2,
    data.terraform_remote_state.core_vpc.outputs.vpc_private-subnet-az3
  ]

  db_subnets = [data.terraform_remote_state.core_vpc.outputs.vpc_db-subnet-az1,
    data.terraform_remote_state.core_vpc.outputs.vpc_db-subnet-az2,
    data.terraform_remote_state.core_vpc.outputs.vpc_db-subnet-az3
  ]

  #------------------------------------
  # ALB - Website
  #------------------------------------
  alb_name            = "${local.common_name}-lb"
  alb_path            = "/"
  alb_subnets         = local.public_subnets
  alb_security_groups = [data.terraform_remote_state.security_groups.outputs.cporacle_lb.id]
  internal_alb        = false
  idle_timeout        = 60
  elb_logs_s3_bucket  = data.terraform_remote_state.common.outputs.alb_access_logs_s3_bucket.bucket

  # ALB Listener - Website
  alb_listener_web_port            = 443
  alb_listener_web_protocol        = "HTTPS"
  alb_listener_web_ssl_policy      = "ELBSecurityPolicy-2016-08"
  alb_listener_web_certificate_arn = data.terraform_remote_state.core_vpc.outputs.strategic_public_ssl_arn[0]
  
  # ALB Target Group - Website
  target_group_web_name   = "${local.common_name}-asg-target-group"
  target_group_web_sticky = false

  health_check_target_group_web_path = "/karma.html"
  target_group_web_port = 80
  web_svc_port = 80
 
  #------------------------------------
  # ALB - API
  #------------------------------------
  alb_api_name            = "${local.common_name}-lb-api"
  alb_api_path            = "/"
  alb_api_subnets         = local.public_subnets
  alb_api_security_groups = [data.terraform_remote_state.security_groups.outputs.cporacle_lb.id]
  api_internal_alb        = false
  api_idle_timeout        = 60
  api_elb_logs_s3_bucket  = data.terraform_remote_state.common.outputs.alb_access_logs_s3_bucket.bucket

  # ALB Listener - API
  alb_listener_api_port            = 443
  alb_listener_api_protocol        = "HTTPS"
  alb_listener_api_ssl_policy      = "ELBSecurityPolicy-2016-08"
  alb_listener_api_certificate_arn = data.terraform_remote_state.core_vpc.outputs.strategic_public_ssl_arn[0]
  
  # ALB Target Group - API
  target_group_api_name   = "${local.common_name}-asg-api-target-group"
  target_group_api_sticky = false

  health_check_target_group_api_path = "/karma.html" # update to the new healthcheck endpoint when AMI for API is ready
  target_group_api_port = 80
  api_svc_port = 80

}
