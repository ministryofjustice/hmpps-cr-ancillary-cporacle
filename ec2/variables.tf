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

variable "project_name" {
  type = string
}


variable "cporacle_asg_props" {
  type = map(string)
}

variable "cporacle_api_asg_props" {
  type = map(string)
}

variable "log_retention" {
  type = string
}