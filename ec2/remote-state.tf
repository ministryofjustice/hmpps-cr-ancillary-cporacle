data "terraform_remote_state" "cporacle_common" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "cp-oracle/common/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "cporacle_iam" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "cp-oracle/iam/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "cporacle_security_groups" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "cp-oracle/security-groups/terraform.tfstate"
    region = var.region
  }
}
//This is not available due to build order
//data "terraform_remote_state" "alb" {
//  backend = "s3"
//
//  config = {
//    bucket = var.remote_state_bucket_name
//    key    = "cp-oracle/alb/terraform.tfstate"
//    region = var.region
//  }
//}


data "terraform_remote_state" "core_vpc" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "vpc/terraform.tfstate"
    region = var.region
  }
}