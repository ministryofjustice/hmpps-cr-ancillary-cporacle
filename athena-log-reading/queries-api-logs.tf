resource "aws_athena_named_query" "cporacle_logs_api_top_100" {
  name      = "cporacle_logs_api_top_100"
  workgroup = aws_athena_workgroup.cporacle.id
  database  = aws_athena_database.cporacle.name
  query     = "SELECT * FROM ${aws_athena_database.cporacle.name}.${local.table_name_alb_access_logs_api} LIMIT 100;"
}

resource "aws_athena_named_query" "cporacle_logs_api_top_100_clients" {
  name      = "cporacle_logs_api_top_100_clients"
  workgroup = aws_athena_workgroup.cporacle.id
  database  = aws_athena_database.cporacle.name
  query     = "SELECT COUNT(request_verb) AS count, request_verb, client_ip FROM ${aws_athena_database.cporacle.name}.${local.table_name_alb_access_logs_api} GROUP BY request_verb, client_ip LIMIT 100;"
}