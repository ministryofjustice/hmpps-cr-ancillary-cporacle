terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {
  }
}

#-------------------------------------------------------------
## Getting the rds db password
#-------------------------------------------------------------
# data "aws_ssm_parameter" "db_password" {
#   name = "/${local.environment_name}/${local.common_name}/cporacle_rds_admin_password"
# }

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
### IAM ROLE FOR RDS
#-------------------------------------------------------------
# module "rds_monitoring_role" {
#   source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//iam//role?ref=terraform-0.12"
#   rolename   = "${local.common_name}-monitoring"
#   policyfile = "rds_monitoring.json"
# }

# resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
#   role       = module.rds_monitoring_role.iamrole_name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
# }

############################################
# CREATE DB SUBNET GROUP
############################################
# module "db_subnet_group" {
#   source      = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//rds//db_subnet_group?ref=terraform-0.12"
#   create      = true
#   identifier  = local.common_name
#   name_prefix = "${local.common_name}-"
#   subnet_ids  = local.rds_subnets
#   tags        = local.tags
# }

resource "aws_db_subnet_group" "cporacle" {
  name_prefix = "${local.common_name}-"
  description = "Database subnet group for ${local.common_name}"
  subnet_ids  = local.rds_subnets

  tags = merge(
    local.tags,
    map("Name", format("%s", local.common_name))
  )
}

############################################
# CREATE PARAMETER GROUP
############################################
# module "db_parameter_group" {
#   source      = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//rds//db_parameter_group?ref=terraform-0.12"
#   create      = true
#   identifier  = local.common_name
#   name_prefix = "${local.common_name}-"
#   family      = local.rds_family
#   parameters  = local.rds_parameters
#   tags        = local.tags
# }

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

############################################
# CREATE DB OPTIONS
############################################
# module "db_option_group" {
#   source                   = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//rds//db_option_group?ref=terraform-0.12"
#   create                   = true
#   identifier               = local.common_name
#   name_prefix              = "${local.common_name}-"
#   option_group_description = "${local.common_name} options group"
#   engine_name              = local.rds_engine
#   major_engine_version     = local.rds_major_engine_version
#   options                  = local.rds_options
#   tags                     = local.tags
# }

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
  allocated_storage          = local.rds_allocated_storage
  apply_immediately          = local.rds_apply_immediately
  auto_minor_version_upgrade = local.rds_allow_auto_minor_version_upgrade
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
  # name                       = upper(local.rds_name)
  option_group_name          = aws_db_option_group.cporacle.name
  parameter_group_name       = aws_db_parameter_group.cporacle.name
  password                   = local.rds_db_password
  # performance_insights_enabled = local.rds_performance_insights_enabled
  # performance_insights_kms_key_id = local.rds_performance_insights_retention_period
  # performance_insights_retention_period
  publicly_accessible    = local.rds_publicly_accessible
  skip_final_snapshot    = local.rds_skip_final_snapshot
  storage_type           = local.rds_storage_type
  storage_encrypted      = local.rds_storage_encrypted
  timezone               = local.rds_timezone
  username               = local.rds_db_identity
  vpc_security_group_ids = local.rds_vpc_security_group_ids
}

# resource "aws_db_instance_role_association" "rds_cporacle" {
#   db_instance_identifier = aws_db_instance.cporacle.id
#   feature_name           = "S3_INTEGRATION"
#   role_arn               = aws_iam_role.example.arn
# }

############################################
# CREATE DB INSTANCE
############################################
#  module "db_instance" {
#   source            = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//rds//db_instance?ref=terraform-0.12"
#   create            = true
#   identifier        = local.common_name
#   engine            = local.engine
#   engine_version    = local.engine_version
#   instance_class    = local.instance_class
#   allocated_storage = local.allocated_storage
#   storage_type      = local.storage_type
#   storage_encrypted = local.storage_encrypted
#   kms_key_id        = module.kms_key.kms_arn
#   license_model     = var.license_model

#   name              = upper(local.db_identity)
#   username          = local.db_identity
#   password          = local.db_password
#   port              = var.port
# #   iam_database_authentication_enabled = var.iam_database_authentication_enabled

# #   replicate_source_db = var.replicate_source_db

# #   snapshot_identifier = var.snapshot_identifier

# #   vpc_security_group_ids = local.security_group_ids

# #   db_subnet_group_name = module.db_subnet_group.db_subnet_group_id
# #   parameter_group_name = aws_db_parameter_group.iaps_parameter_group.name
# #   option_group_name    = aws_db_option_group.iaps_option_group.name
# #   multi_az             = local.multi_az 
# #   iops                 = var.iops
# #   publicly_accessible  = var.publicly_accessible

# #   allow_major_version_upgrade = var.allow_major_version_upgrade
# #   auto_minor_version_upgrade  = var.auto_minor_version_upgrade
# #   apply_immediately           = true
#   maintenance_window          = local.maintenance_window
# #   skip_final_snapshot         = var.skip_final_snapshot
# #   copy_tags_to_snapshot       = var.copy_tags_to_snapshot
# #   final_snapshot_identifier   = "${local.common_name}-final-snapshot"

#   backup_retention_period = local.rds_backup_retention_period
#   backup_window           = local.backup_window

# #   monitoring_interval  = var.rds_monitoring_interval
# #   monitoring_role_arn  = module.rds_monitoring_role.iamrole_arn
# #   monitoring_role_name = module.rds_monitoring_role.iamrole_name

# #   timezone           = var.timezone
# #   character_set_name = local.character_set_name

#   tags = merge(
#     local.tags,
#     {
#       "Name" = upper(local.db_identity)
#     }
#   )

#   enabled_cloudwatch_logs_exports = local.enabled_cloudwatch_logs_exports
# }

###############################################
# Create route53 entry for rds
###############################################

# resource "aws_route53_record" "rds_dns_entry" {
#   name    = "${local.dns_name}.${local.internal_domain}"
#   type    = "CNAME"
#   zone_id = local.private_zone_id
#   ttl     = 300
#   records = [module.db_instance.db_instance_address]
# }
