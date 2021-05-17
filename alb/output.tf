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

output "alb_website" {
  value = aws_alb.alb
}

output "alb_api" {
  value = aws_alb.alb_api
}

output "aws_route53_record_cporacle" {
  value = aws_route53_record.cporacle
}

output "aws_route53_record_cporacle_api" {
  value = aws_route53_record.cporacle_api
}

output "alb_target_group_web" {
  value = aws_alb_target_group.alb_target_group
}

output "alb_target_group_api" {
  value = aws_alb_target_group.alb_target_group_api
}
