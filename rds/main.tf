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

module "rds_monitoring_role" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//iam//role?ref=terraform-0.12"
  rolename   = "${local.common_name}-monitoring"
  policyfile = "rds_monitoring.json"
}

resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  role       = module.rds_monitoring_role.iamrole_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

############################################
# CREATE DB SUBNET GROUP
############################################
module "db_subnet_group" {
  source      = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//rds//db_subnet_group?ref=terraform-0.12"
  create      = true
  identifier  = local.common_name
  name_prefix = "${local.common_name}-"
  subnet_ids  = local.rds_subnets
  tags        = local.tags
}

############################################
# CREATE PARAMETER GROUP
############################################
module "db_parameter_group" {
  source      = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//rds//db_parameter_group?ref=terraform-0.12"
  create      = true
  identifier  = local.common_name
  name_prefix = "${local.common_name}-"
  family      = local.rds_family
  parameters  = local.rds_parameters
  tags        = local.tags
}

############################################
# CREATE DB OPTIONS
############################################
module "db_option_group" {
  source                   = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//rds//db_option_group?ref=terraform-0.12"
  create                   = true
  identifier               = local.common_name
  name_prefix              = "${local.common_name}-"
  option_group_description = "${local.common_name} options group"
  engine_name              = local.rds_engine
  major_engine_version     = local.rds_major_engine_version
  options                  = local.rds_options
  tags                     = local.tags
}

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
#   storage_type      = var.storage_type
#   storage_encrypted = var.storage_encrypted
#   kms_key_id        = module.kms_key.kms_arn
#   license_model     = var.license_model

#   name                                = upper(local.db_identity)
#   username                            = local.db_identity
#   password                            = local.db_password
#   port                                = var.port
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

# backup_retention_period = local.rds_backup_retention_period
# backup_window           = local.backup_window

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
