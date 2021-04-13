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

output "private_subnets" {
  value = local.private_subnets
}

output "db_subnets" {
  value = local.db_subnets
}

output "ssh_deployer_key" {
  value = local.ssh_deployer_key
}

output "cporacle_lb" {
  value = aws_security_group.cporacle_lb
}

output "cporacle_appservers" {
  value = aws_security_group.cporacle_appservers
}

output "cporacle_db" {
  value = aws_security_group.cporacle_db
}
