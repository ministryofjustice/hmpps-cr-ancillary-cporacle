resource "aws_alb_target_group" "alb_target_group" {
  name     = local.target_group_name
  port     = local.svc_port
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  tags = merge(
    local.tags,
    {
      Name = local.target_group_name
    }
  )

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = local.health_check_target_group_path
    port                = local.target_group_port
  }
}

