# Web App instance cloudwatch config file
data "template_file" "APP_cloudwatch_config" {
  template = file("./files/config.json")
  vars = {
    log_group_name                   = local.app_log_group_name
    system_event_log_group_name      = local.app_system_events_log_group_name
    application_event_log_group_name = local.app_application_events_log_group_name
  }
}

resource "aws_s3_bucket_object" "APP_cloudwatch_config" {
  bucket  = local.artifacts_s3_bucket_name
  key     = "/cloudwatch/app_config.json"
  content = data.template_file.APP_cloudwatch_config.rendered
}

# API instance cloudwatch config file
data "template_file" "API_cloudwatch_config" {
  template = file("./files/config.json")
  vars = {
    log_group_name                   = local.api_log_group_name
    system_event_log_group_name      = local.api_system_events_log_group_name
    application_event_log_group_name = local.api_application_events_log_group_name
  }
}

resource "aws_s3_bucket_object" "API_cloudwatch_config" {
  bucket  = local.artifacts_s3_bucket_name
  key     = "/cloudwatch/api_config.json"
  content = data.template_file.API_cloudwatch_config.rendered
}
