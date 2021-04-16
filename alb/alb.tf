resource "aws_alb" "alb" {
  name            = local.alb_name
  subnets         = local.alb_subnets
  security_groups = local.alb_security_groups
  internal        = local.internal_alb
  idle_timeout    = local.idle_timeout
  tags = merge(
    local.tags,
    {
      Name = local.alb_name
    }
  )
  access_logs {
    bucket = local.elb_logs_s3_bucket
    prefix = "ELB-logs"
  }
}

resource "aws_alb_listener" "alb_listener_https" {
  load_balancer_arn = aws_alb.alb.arn
  port              = local.alb_listener_port
  protocol          = local.alb_listener_protocol

  ssl_policy      = local.alb_listener_ssl_policy
  certificate_arn = local.alb_listener_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.arn
  }
}

resource "aws_alb_listener_rule" "listener_rule_https" {
  depends_on   = [aws_alb_target_group.alb_target_group]
  listener_arn = aws_alb_listener.alb_listener_https.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.id
  }
  condition {
    field  = "path-pattern"
    values = [local.alb_path]
  }
}

resource "aws_alb_listener" "alb_listener_redirect_to_https" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "redirect"
    
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_autoscaling_attachment" "cporacle" {
  alb_target_group_arn   = aws_alb_target_group.alb_target_group.arn
  autoscaling_group_name = data.terraform_remote_state.ec2.outputs.cporacle_app_asg.name
}

