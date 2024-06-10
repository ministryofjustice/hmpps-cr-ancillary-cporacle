
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
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "cporacle_lb_http_ingress_80_self" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.cporacle_lb.id
  description       = "CP-Oracle ALB Internal LB http"
}

resource "aws_security_group_rule" "cporacle_lb_https_ingress_443_self" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.cporacle_lb.id
  description       = "CP-Oracle ALB Internal LB https"
}

resource "aws_security_group_rule" "application_access_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.cporacle_lb.id
  description       = "MOJ VPN and ARK http"
  cidr_blocks = concat(
    var.cr_ancillary_admin_cidrs,
    var.cr_ancillary_access_cidrs
  )
}

resource "aws_security_group_rule" "application_access_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.cporacle_lb.id
  description       = "MOJ VPN and ARK https"
  cidr_blocks = concat(
    var.cr_ancillary_admin_cidrs,
    var.cr_ancillary_access_cidrs
  )
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

resource "aws_security_group_rule" "cporacle_lb_appservers_ingress_http" {
  security_group_id = aws_security_group.cporacle_lb.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  type              = "ingress"
  description       = "${local.common_name}-http-in-via-bastion"
  cidr_blocks = concat(
    local.bastion_cidr,
  )
}

resource "aws_security_group_rule" "cporacle_lb_appservers_ingress_https" {
  security_group_id = aws_security_group.cporacle_lb.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  type              = "ingress"
  description       = "${local.common_name}-https-in-via-bastion"
  cidr_blocks = concat(
    local.bastion_cidr,
  )
}

# Route53 healthcheck
resource "aws_security_group_rule" "route53_heatlcheck_ingress_https" {
  security_group_id = aws_security_group.cporacle_lb.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = concat(
    var.cr_ancillary_route53_healthcheck_access_cidrs
  )
  ipv6_cidr_blocks = concat(
    var.cr_ancillary_route53_healthcheck_access_ipv6_cidrs
  )
  description = "Application Route53 health check Access - Https"
}
