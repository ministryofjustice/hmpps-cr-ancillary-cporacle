variable "region" {
}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}

variable "environment_name" {
  type = string
}

variable "project_name" {
  type = string
}

# PARAMETER GROUP
variable "parameters" {
  description = "A list of DB parameter maps to apply"
  default     = []
}

# DB option group
variable "options" {
  type        = list(any)
  description = "A list of Options to apply."
  default     = []
}

# INSTANCE
variable "rds_family" {
}

variable "rds_major_engine_version" {
}

variable "rds_engine" {
}

variable "rds_engine_version" {
  description = "The engine version to use"
}

variable "rds_instance_class" {
  description = "The instance type of the RDS instance"
}

variable "rds_allocated_storage" {
  description = "The allocated storage in gigabytes"
}

variable "rds_max_allocated_storage" {
  description = "The max allocated storage in gigabytes"
}

variable "rds_username" {
  description = ""
}

variable "rds_random_password_length" {
  description = ""
  default     = 16
  type        = number
}

variable "rds_create_random_password" {
  description = ""
  type        = bool
}

variable "rds_storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'standard' if not. Note that this behaviour is different from the AWS web console, where the default is 'gp2'."
  default     = "gp2"
}

variable "rds_storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  default     = false
}

variable "rds_license_model" {
  description = "License model information for this DB instance. Optional, but required for some DB engines, i.e. Oracle SE1"
  default     = ""
}

variable "rds_port" {
  description = "The port on which the DB accepts connections"
  default     = 1521
}

variable "rds_iam_database_authentication_enabled" {
  description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled"
  default     = false
}

variable "rds_replicate_source_db" {
  description = "Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the identifier of another Amazon RDS Database to replicate."
  default     = ""
}

variable "rds_snapshot_identifier" {
  description = "Specifies whether or not to create this database from a snapshot. This correlates to the snapshot ID you'd find in the RDS console, e.g: rds:production-2015-06-26-06-05."
  default     = ""
}

variable "rds_iops" {
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'"
  default     = 0
}

variable "rds_publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
  default     = false
}

variable "rds_allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible"
  default     = false
}

variable "rds_allow_auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  default     = true
}

variable "rds_apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  default     = false
}

variable "rds_maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
}

variable "rds_skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
  default     = true
}

variable "rds_copy_tags_to_snapshot" {
  description = "On delete, copy all Instance tags to the final snapshot (if final_snapshot_identifier is specified)"
  default     = false
}

variable "rds_backup_retention_period" {
  description = "The days to retain backups for"
  default     = 1
}

variable "rds_backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
}

variable "rds_monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60."
  default     = 0
}

variable "rds_timezone" {
  description = "(Optional) Time zone of the DB instance. timezone is currently only supported by Microsoft SQL Server. The timezone can only be set on creation. See MSSQL User Guide for more information."
  default     = ""
}

variable "rds_character_set_name" {
  description = "(Optional) The character set name to use for DB encoding in Oracle instances. This can't be changed. See Oracle Character Sets Supported in Amazon RDS for more information."
  default     = ""
}

variable "environment_type" {
  description = "The environment type - e.g. dev"
}

variable "rds_multi_az" {
  type    = bool
  default = true
}

variable "rds_enabled_cloudwatch_logs_exports" {
  description = ""
}

variable "rds_parameters" {
  description = ""
}
variable "rds_create_db_parameter_group" {
  description = ""
}
variable "rds_create_monitoring_role" {
  description = ""
}
variable "rds_performance_insights_retention_period" {
  description = ""
}
variable "rds_performance_insights_enabled" {
  description = ""
}
variable "rds_deletion_protection" {
  description = ""
}

variable "rds_options" {
  description = ""
}

variable "rds_delete_automatic_backups" {
  type = bool
}