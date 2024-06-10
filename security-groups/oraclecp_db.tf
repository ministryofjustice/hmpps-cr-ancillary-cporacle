# RDS Security Group
resource "aws_security_group" "cporacle_db" {
  name        = "cporacle-db"
  description = "CP-Oracle RDS Instances Security Group"
  vpc_id      = local.vpc_id
  tags = merge(
    local.tags,
    {
      "Name" = "cporacle-db"
    }
  )
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "cporacle_db_ingress_1433" {
  type                     = "ingress"
  from_port                = 1433
  to_port                  = 1433
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.cporacle_appservers.id
  security_group_id        = aws_security_group.cporacle_db.id
  description              = "CPOracle Application to MS SQL Server"
}

resource "aws_security_group_rule" "cporacle_db_ingress_sql_1433" {
  security_group_id = aws_security_group.cporacle_db.id
  from_port         = 1433
  to_port           = 1433
  protocol          = "tcp"
  type              = "ingress"
  description       = "${local.common_name}-1433-in-via-bastion"
  cidr_blocks = concat(
    local.bastion_cidr,
  )
}
