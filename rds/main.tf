terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {
  }
}
############################################
# KMS KEY GENERATION - FOR ENCRYPTION
############################################
module "kms_key" {
  source              = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//kms?ref=terraform-0.12"
  kms_key_name        = local.common_name
  tags                = local.tags
  kms_policy_location = var.environment_type == "prod" ? "policies/kms-cross-account-policy.json" : "policies/kms-policy-${local.environment_name}.json"
}

#-------------------------------------------------------------
## Getting the rds db password
#-------------------------------------------------------------
data "aws_ssm_parameter" "rds_master_password" {
  name = "/${local.environment_name}/${local.project_name}/cporacle/rds/rds_master_password"
}

#-------------------------------------------------------------
## rds kms encryption
#-------------------------------------------------------------
data "aws_kms_key" "by_alias_arn" {
  key_id = "arn:aws:kms:eu-west-2:${local.account_id}:alias/aws/rds"
}

resource "aws_db_subnet_group" "cporacle" {
  name_prefix = "${local.common_name}-"
  description = "Database subnet group for ${local.common_name}"
  subnet_ids  = local.rds_subnets

  tags = merge(
    local.tags,
    map("Name", format("%s", local.common_name))
  )
}

resource "aws_db_parameter_group" "cporacle" {
  name_prefix = "${local.common_name}-"
  description = "Database parameter group for ${local.common_name}"
  family      = local.rds_family

  dynamic "parameter" {

    for_each = local.rds_parameters

    content {
      name  = parameter.key
      value = parameter.value
    }
  }

  tags = merge(
    local.tags,
    map("Name", format("%s", local.common_name))
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_option_group" "cporacle" {
  name_prefix              = "${local.common_name}-"
  option_group_description = "${local.common_name} options group"
  engine_name              = local.rds_engine
  major_engine_version     = local.rds_major_engine_version

  dynamic "option" {
    for_each = local.rds_options
    content {
      option_name                    = option.value.option_name
      port                           = lookup(option.value, "port", null)
      version                        = lookup(option.value, "version", null)
      db_security_group_memberships  = lookup(option.value, "db_security_group_memberships", null)
      vpc_security_group_memberships = lookup(option.value, "vpc_security_group_memberships", null)

      dynamic "option_settings" {
        for_each = lookup(option.value, "option_settings", [])
        content {
          name  = lookup(option_settings.value, "name", null)
          value = lookup(option_settings.value, "value", null)
        }
      }
    }
  }

  tags = merge(
    local.tags,
    map("Name", format("%s", local.common_name))
  )
}

resource "aws_db_instance" "cporacle" {
  identifier                 = "${local.common_name}-native-backup-restore"
  
  allocated_storage          = local.rds_allocated_storage
  max_allocated_storage      = local.rds_max_allocated_storage 
  
  apply_immediately          = local.rds_apply_immediately
  auto_minor_version_upgrade = local.rds_allow_auto_minor_version_upgrade
  backup_retention_period    = local.rds_backup_retention_period
  enabled_cloudwatch_logs_exports = local.rds_enabled_cloudwatch_logs_exports
  copy_tags_to_snapshot      = local.rds_copy_tags_to_snapshot
  db_subnet_group_name       = aws_db_subnet_group.cporacle.name
  delete_automated_backups   = local.rds_delete_automatic_backups
  engine                     = local.rds_engine
  engine_version             = local.rds_engine_version
  instance_class             = local.rds_instance_class
  kms_key_id                 = module.kms_key.kms_arn
  license_model              = local.rds_license_model
  maintenance_window         = local.rds_maintenance_window
  monitoring_interval        = local.rds_monitoring_interval
  monitoring_role_arn        = local.rds_monitoring_role_arn
  multi_az                   = local.rds_multi_az
  option_group_name          = aws_db_option_group.cporacle.name
  parameter_group_name       = aws_db_parameter_group.cporacle.name
  password                   = data.aws_ssm_parameter.rds_master_password.value

  performance_insights_enabled          = local.rds_performance_insights_enabled
  performance_insights_kms_key_id       = data.aws_kms_key.by_alias_arn.arn
  performance_insights_retention_period = local.rds_performance_insights_retention_period

  publicly_accessible    = local.rds_publicly_accessible
  skip_final_snapshot    = local.rds_skip_final_snapshot
  storage_type           = local.rds_storage_type
  storage_encrypted      = local.rds_storage_encrypted
  timezone               = local.rds_timezone
  username               = local.rds_db_identity
  vpc_security_group_ids = local.rds_vpc_security_group_ids

  tags = merge(local.tags,
              {
                "Name" = "${local.common_name}-native-sql"
              }
  )
}

resource "aws_db_instance_role_association" "rds_cporacle" {
  db_instance_identifier = aws_db_instance.cporacle.id
  feature_name           = "S3_INTEGRATION"
  role_arn               = local.rds_native_sql_backups_iam_role_arn
}
