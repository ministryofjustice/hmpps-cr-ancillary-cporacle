#-------------------------------------------------------------
### Getting the common details
#-------------------------------------------------------------
data "terraform_remote_state" "common" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "cp-oracle/common/terraform.tfstate"
    region = var.region
  }
}

#-------------------------------------------------------------
### Getting the EC2 details
#-------------------------------------------------------------
data "terraform_remote_state" "ec2" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "cp-oracle/ec2/terraform.tfstate"
    region = var.region
  }
}
