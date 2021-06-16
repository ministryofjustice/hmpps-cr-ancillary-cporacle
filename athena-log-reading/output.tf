output "database_info" {
  value = {
    instance_id           = aws_athena_database.cporacle.id
  }
}
