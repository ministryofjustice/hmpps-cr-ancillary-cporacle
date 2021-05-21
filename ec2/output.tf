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

output "cporacle_log_group_cloudwatch_agent_api" {
  value = aws_cloudwatch_log_group.cporacle_log_group_cloudwatch_agent_api
}

output "cporacle_log_group_cporacle_api" {
  value = aws_cloudwatch_log_group.cporacle_log_group_cporacle_api
}

output "cporacle_log_group_system_events_api" {
  value = aws_cloudwatch_log_group.cporacle_log_group_system_events_api
}

output "cporacle_log_group_application_events_api" {
  value = aws_cloudwatch_log_group.cporacle_log_group_application_events_api
}


output "cporacle_log_group_cloudwatch_agent" {
  value = aws_cloudwatch_log_group.cporacle_log_group_cloudwatch_agent
}

output "cporacle_log_group_cporacle_application" {
  value = aws_cloudwatch_log_group.cporacle_log_group_cporacle_application
}

output "cporacle_log_group_system_events" {
  value = aws_cloudwatch_log_group.cporacle_log_group_system_events

}

output "cporacle_log_group_application_events" {
  value = aws_cloudwatch_log_group.cporacle_log_group_application_events
}

