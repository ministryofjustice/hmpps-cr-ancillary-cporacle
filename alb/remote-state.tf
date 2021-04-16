data "terraform_remote_state" "common" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "cp-oracle/common/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "iam" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "cp-oracle/iam/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "security_groups" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "cp-oracle/security-groups/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "ec2" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "cp-oracle/ec2/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "core_vpc" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "vpc/terraform.tfstate"
    region = var.region
  }
}