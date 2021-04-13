
# ALB Security Group
resource "aws_security_group" "cporacle_lb" {
  name        = "cporacle-lb"
  description = "CP-Oracle Application Load Balancer Security Group"
  vpc_id      = local.vpc_id
  tags = merge(
    local.tags,
    {
      "Name" = "cporacle-lb"
    }
  )
}

resource "aws_security_group_rule" "cporacle_lb_http_ingress_80_self" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  self                     = true
  security_group_id        = aws_security_group.cporacle_lb.id
  description              = "CP-Oracle ALB Internal LB http"
}

resource "aws_security_group_rule" "cporacle_lb_https_ingress_443_self" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  self                     = true
  security_group_id        = aws_security_group.cporacle_lb.id
  description              = "CP-Oracle ALB Internal LB https"
}

resource "aws_security_group_rule" "cporacle_lb_http_egress_80_appservers" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.cporacle_appservers.id
  security_group_id        = aws_security_group.cporacle_lb.id
  description              = "CP-Oracle ALB to Application Servers http"
}
