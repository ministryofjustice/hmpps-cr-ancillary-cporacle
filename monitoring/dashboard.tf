data "template_file" "dashboard" {
  template = file("./templates/dashboard.json")
  vars = {
    region = var.region
  }
}

resource "aws_cloudwatch_dashboard" "cporacle" {
  dashboard_name = var.environment_name
  dashboard_body = data.template_file.dashboard.rendered
}
