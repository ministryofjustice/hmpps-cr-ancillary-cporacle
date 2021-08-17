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

variable "cr_ancillary_route53_healthcheck_access_cidrs" {
  type    = list(any)
  default = []
}

variable "cr_ancillary_route53_healthcheck_access_ipv6_cidrs" {
  type    = list(any)
  default = []
}

variable "cr_ancillary_admin_cidrs" {
  type    = list(any)
  default = []
}

variable "cr_ancillary_access_cidrs" {
  type    = list(any)
  default = []
}

