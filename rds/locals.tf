locals {

  project_name     = var.project 
  common_name      = data.terraform_remote_state.common.outputs.common_name
  environment_name = var.environment_name
  account_id       = data.terraform_remote_state.vpc.outputs.vpc_account_id
  region           = var.region

  vpc_id         = data.terraform_remote_state.vpc.outputs.vpc_id
  vpc_cidr_block = data.terraform_remote_state.vpc.outputs.vpc_cidr_block

  private_zone_id   = data.terraform_remote_state.vpc.outputs.private_zone_id   # Z0172977282BF556T2PJT
  private_zone_name = data.terraform_remote_state.vpc.outputs.private_zone_name # unpaid.work.dev.cr.internal

  tags = data.terraform_remote_state.common.outputs.tags

  rds_engine               = var.rds_engine
  rds_engine_version       = var.rds_engine_version
  rds_family               = var.rds_family
  rds_major_engine_version = var.rds_major_engine_version
  rds_instance_class       = var.rds_instance_class

  rds_storage_type          = var.rds_storage_type
  rds_allocated_storage     = var.rds_allocated_storage
  rds_max_allocated_storage = var.rds_max_allocated_storage
  rds_storage_encrypted     = var.rds_storage_encrypted

  rds_username               = var.rds_username
  rds_create_random_password = false
  rds_random_password_length = false
  rds_port                   = var.rds_port

  # rds_domain               = var.rds_domain
  # rds_domain_iam_role_name = var.rds_domain_iam_role_name

  rds_multi_az = var.rds_multi_az
  rds_subnets = [data.terraform_remote_state.vpc.outputs.vpc_db-subnet-az1,
    data.terraform_remote_state.vpc.outputs.vpc_db-subnet-az2,
    data.terraform_remote_state.vpc.outputs.vpc_db-subnet-az3
  ]

  rds_vpc_security_group_ids = [data.terraform_remote_state.security_groups.outputs.cporacle_db.id]

  rds_maintenance_window              = var.rds_maintenance_window
  rds_backup_window                   = var.rds_backup_window
  rds_enabled_cloudwatch_logs_exports = var.rds_enabled_cloudwatch_logs_exports

  rds_backup_retention_period  = var.rds_backup_retention_period
  rds_skip_final_snapshot      = var.rds_skip_final_snapshot
  rds_copy_tags_to_snapshot    = var.rds_copy_tags_to_snapshot
  rds_deletion_protection      = var.rds_deletion_protection
  rds_delete_automatic_backups = var.rds_delete_automatic_backups

  rds_performance_insights_enabled          = var.rds_performance_insights_enabled
  rds_performance_insights_retention_period = var.rds_performance_insights_retention_period
  
  rds_monitoring_role_arn                   = data.terraform_remote_state.iam.outputs.rds_monitoring_role.iamrole_arn
  rds_monitoring_interval                   = var.rds_monitoring_interval

  rds_native_sql_backups_iam_role_arn = data.terraform_remote_state.iam.outputs.cporacle_native_sql_backups_iam_role.arn

  # rds_options                   = var.rds_options

  #------------------------------------------------------------------------------------------------
  # https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.SQLServer.Options.html
  #------------------------------------------------------------------------------------------------
  rds_options = [
    # {
    #   option_name = "Timezone"

    #   option_settings = [
    #     {
    #       name  = "TIME_ZONE"
    #       value = "UTC"
    #     },
    #   ]
    # },
    {
      option_name = "SQLSERVER_BACKUP_RESTORE"

      option_settings = [
        {
          name  = "IAM_ROLE_ARN"
          value = local.rds_native_sql_backups_iam_role_arn
        },
      ]
    },
    {
      option_name = "TDE"

      option_settings = [
        
      ]
    },
  ]

  rds_create_db_parameter_group = var.rds_create_db_parameter_group
  rds_parameters                = var.rds_parameters
  rds_license_model             = var.rds_license_model
  rds_timezone                  = var.rds_timezone
  rds_character_set_name        = var.rds_character_set_name

  rds_iam_database_authentication_enabled = var.rds_iam_database_authentication_enabled
  rds_replicate_source_db                 = var.rds_replicate_source_db
  rds_snapshot_identifier                 = var.rds_snapshot_identifier
  rds_iops                                = var.rds_iops
  rds_publicly_accessible                 = var.rds_publicly_accessible
  rds_allow_major_version_upgrade         = var.rds_allow_major_version_upgrade
  rds_allow_auto_minor_version_upgrade    = var.rds_allow_auto_minor_version_upgrade
  rds_apply_immediately                   = var.rds_apply_immediately

  rds_db_identity = "admin"
  rds_db_password = "rgefdberfbtrebn134345"
}