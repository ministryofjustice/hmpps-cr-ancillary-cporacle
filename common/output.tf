output "common_name" {
  value = local.common_name
}

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

output "public_subnets" {
  value = local.public_subnets
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

output "alb_access_logs_s3_bucket" {
  value = aws_s3_bucket.alb_access_logs_s3_bucket
}

output "cporacle_artifacts_s3_bucket" {
  value = aws_s3_bucket.cporacle_artifacts
}
