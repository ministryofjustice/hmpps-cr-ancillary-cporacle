resource "random_string" "rds_master_password_string" {
  length  = 32
  special = true
}

resource "aws_ssm_parameter" "rds_master_password" {
  name        = "/${var.environment_name}/${var.project_name}/cporacle/rds/rds_master_password"
  description = "CPOracle RDS Instance Master Password"
  type        = "SecureString"
  value       = random_string.rds_master_password_string.result

  tags = merge(
    local.tags,
    {
      "Name" = "/${var.environment_name}/${var.project_name}/cporacle/rds/rds_master_password"
    },
  )

  lifecycle {
    ignore_changes = [value]
  }
}

resource "random_string" "rds_cporacle_app_password" {
  length  = 32
  special = false
}

resource "aws_ssm_parameter" "rds_cporacle_app_password" {
  name        = "/${var.environment_name}/${var.project_name}/cporacle/rds/cporacle_app_password"
  description = "CPOracle Application Password"
  type        = "SecureString"
  value       = random_string.rds_cporacle_app_password.result

  tags = merge(
    local.tags,
    {
      "Name" = "/${var.environment_name}/${var.project_name}/cporacle/rds/cporacle_app_password"
    },
  )

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "rds_cporacle_app_username" {
  name        = "/${var.environment_name}/${var.project_name}/cporacle/rds/cporacle_app_username"
  description = "CPOracle RDS User Name"
  type        = "String"
  value       = local.RDSUsername

  tags = merge(
    local.tags,
    {
      "Name" = "/${var.environment_name}/${var.project_name}/cporacle/rds/cporacle_app_username"
    },
  )

  lifecycle {
    ignore_changes = [value]
  }
}