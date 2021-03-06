data "terraform_remote_state" "common" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "cp-oracle/common/terraform.tfstate"
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

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "vpc/terraform.tfstate"
    region = var.region
  }
}

#-------------------------------------------------------------
### Getting the Monitoring details
#-------------------------------------------------------------
data "terraform_remote_state" "monitoring" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "monitoring/terraform.tfstate"
    region = var.region
  }
}

#-------------------------------------------------------------
### Getting the ALB details
#-------------------------------------------------------------
data "terraform_remote_state" "alb" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "cp-oracle/alb/terraform.tfstate"
    region = var.region
  }
}
