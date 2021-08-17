resource "aws_alb_target_group" "alb_target_group_api" {
  name     = local.target_group_api_name
  port     = local.api_svc_port
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  tags = merge(
    local.tags,
    {
      Name = local.target_group_api_name
    }
  )

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 5
    timeout             = 3
    interval            = 5
    path                = local.health_check_target_group_api_path
    port                = local.target_group_api_port
  }
}
