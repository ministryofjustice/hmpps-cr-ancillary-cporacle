# EC2 Instances Security Group
resource "aws_security_group" "cporacle_appservers" {
  name        = "cporacle-appservers"
  description = "CP-Oracle Application Server Instances Security Group"
  vpc_id      = local.vpc_id
  tags = merge(
    local.tags,
    {
      "Name" = "cporacle-appservers"
    }
  )
}

resource "aws_security_group_rule" "cporacle_appservers_http_ingress_80" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.cporacle_lb.id
  security_group_id        = aws_security_group.cporacle_appservers.id
  description              = "CP-Oracle ALB to Application Servers http"
}

resource "aws_security_group_rule" "cporacle_appservers_egress_1433_db" {
  type                     = "egress"
  from_port                = 1433
  to_port                  = 1433
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.cporacle_db.id
  security_group_id        = aws_security_group.cporacle_appservers.id
  description              = "CP-Oracle Application Servers to DB 1433"
}

resource "aws_security_group_rule" "cporacle_appservers_egress_https" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.cporacle_appservers.id
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  description              = "CP-Oracle Application Servers to HTTPS (AWS API)"
}

resource "aws_security_group_rule" "cporacle_appservers_ingress_rdp" {
  security_group_id = aws_security_group.cporacle_appservers.id
  from_port         = 3389
  to_port           = 3389
  protocol          = "tcp"

  type              = "ingress"
  description       = "${local.common_name}-rdp-in-via-bastion"
  cidr_blocks = concat(
    local.bastion_cidr,
  )
}

resource "aws_security_group_rule" "cporacle_appservers_ingress_http_bastion" {
  security_group_id = aws_security_group.cporacle_appservers.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  type              = "ingress"
  description       = "${local.common_name}-http-in-via-bastion"
  cidr_blocks = concat(
    local.bastion_cidr,
  )
}