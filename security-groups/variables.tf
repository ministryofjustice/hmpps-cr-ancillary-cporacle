variable "region" {
}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}

variable "environment_type" {
  description = "environment"
}

variable "environment_name" {
  type = string
}

variable "bastion_remote_state_bucket_name" {
  description = "Terraform remote state bucket name for Bastion VPC"
}

variable "bastion_role_arn" {
  description = "role to access bastion terraform state"
}
