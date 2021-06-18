data "template_file" "dashboard" {
  template = file("./templates/dashboard.json")
  vars = {
    region                       = var.region
    db_name                      = local.db_instance_id
    app_asg_autoscale_name       = local.cporacle_app_asg
    app_lb_arn_suffix            = local.cporacle_app_alb["arn_suffix"]
    app_target_group_arn_suffix  = local.cporacle_app_tg["arn_suffix"]
    app_app_pool_httperr_offline = aws_cloudwatch_metric_alarm.APP_iis_httperr.arn
    api_asg_autoscale_name       = local.cporacle_api_asg
    api_lb_arn_suffix            = local.cporacle_api_alb["arn_suffix"]
    api_target_group_arn_suffix  = local.cporacle_api_tg["arn_suffix"]
    api_app_pool_httperr_offline = aws_cloudwatch_metric_alarm.API_iis_httperr.arn
  }
}

resource "aws_cloudwatch_dashboard" "cporacle" {
  dashboard_name = var.environment_name
  dashboard_body = data.template_file.dashboard.rendered
}
