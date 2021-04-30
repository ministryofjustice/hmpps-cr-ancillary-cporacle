resource "random_string" "encryption_key_string" {
  length  = 64
  special = true
}

resource "aws_ssm_parameter" "encryption_key" {
  name        = "/${var.environment_name}/${var.project_name}/cporacle/application/encryption_key"
  description = "CPOracle Application Encryption Key"
  type        = "SecureString"
  value       = random_string.encryption_key_string.result

  tags = merge(
    local.tags,
    {
      "Name" = "/${var.environment_name}/${var.project_name}/cporacle/application/encryption_key"
    },
  )

  lifecycle {
    ignore_changes = [value]
  }
}
