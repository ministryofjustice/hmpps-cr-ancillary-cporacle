# primary ec2
output "admin_instance_ids" {
  value = aws_instance.admin_server.*.id
}

output "admin_private_ips" {
  value = aws_instance.admin_server.*.private_ip
}
