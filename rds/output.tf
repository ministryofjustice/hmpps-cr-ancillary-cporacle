output "account_id" {
  value = local.account_id
}

output "vpc_id" {
  value = local.vpc_id
}

output "vpc_cidr_block" {
  value = local.vpc_cidr_block
}

output "private_zone_id" {
  value = local.private_zone_id
}

output "private_zone_name" {
  value = local.private_zone_name
}

output "tags" {
  value = local.tags
}

output "rds_subnets" {
  value = local.rds_subnets
}

output "kms_key" {
  value = module.kms_key
}

output "db_subnet_group" {
  value = aws_db_subnet_group.cporacle
}

output "db_parameter_group" {
  value = aws_db_parameter_group.cporacle
}

output "db_option_group" {
  value = aws_db_option_group.cporacle
}

output "database_info" {
  value = {
    instance_id = aws_db_instance.cporacle.id
  }
}
