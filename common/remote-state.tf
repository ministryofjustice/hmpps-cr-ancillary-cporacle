# data "terraform_remote_state" "common" {
#   backend = "s3"

#   config = {
#     bucket = var.remote_state_bucket_name
#     key    = "${var.environment_type}/common/terraform.tfstate"
#     region = var.region
#   }
# }

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "vpc/terraform.tfstate"
    region = var.region
  }
}