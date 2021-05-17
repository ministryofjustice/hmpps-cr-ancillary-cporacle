
data "template_file" "alb_create_alblogs_table_website" {
  template = file("templates/create-alblogs-table.tpl")

  vars = {
    table_name  = local.table_name_alb_access_logs_website
    bucket_name = local.alb_access_logs_s3_bucket
    account_id  = local.account_id
    region      = "eu-west-2"
    prefix      = local.common_name
  }
}

resource "null_resource" "alb_create_alblogs_table_website_rendered" {
  triggers = {
    json = data.template_file.alb_create_alblogs_table_website.rendered
  }
}

data "template_file" "alb_create_alblogs_table_api" {
  template = file("templates/create-alblogs-table.tpl")

  vars = {
    table_name  = local.table_name_alb_access_logs_api
    bucket_name = local.alb_access_logs_s3_bucket
    account_id  = local.account_id
    region      = "eu-west-2"
    prefix      = "${local.common_name}-api"
  }
}

resource "null_resource" "alb_create_alblogs_table_api_rendered" {
  triggers = {
    json = data.template_file.alb_create_alblogs_table_api.rendered
  }
}

resource "aws_athena_named_query" "cporacle_create_alb_logs_table_website" {
  name      = "create_alb_logs_table_website"
  workgroup = aws_athena_workgroup.cporacle.id
  database  = aws_athena_database.cporacle.name
  query     = data.template_file.alb_create_alblogs_table_website.rendered
}

resource "aws_athena_named_query" "cporacle_create_alb_logs_table_api" {
  name      = "create_alb_logs_table_api"
  workgroup = aws_athena_workgroup.cporacle.id
  database  = aws_athena_database.cporacle.name
  query     = data.template_file.alb_create_alblogs_table_api.rendered
}