
output "iam_role_cp_oracle" {
  value = module.iam_role_cp_oracle
}

output "iam_instance_profile_cp_oracle" {
  value = module.iam_instance_profile_cp_oracle
}

output "rds_monitoring_role" {
  value = module.rds_monitoring_role
}

output "cporacle_native_sql_backups_iam_role" {
  value = aws_iam_role.cporacle_native_sql_backups_iam_role
}
