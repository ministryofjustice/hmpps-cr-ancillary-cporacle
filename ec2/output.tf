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

output "cporacle_app_launch_template" {
  value = aws_launch_template.cporacle_app
}

output "cporacle_app_asg" {
  value = aws_autoscaling_group.cporacle_app
}