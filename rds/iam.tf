data "template_file" "cporacle_describe_db_instances" {
  template = file("policies/cporacle_ec2_rds_describe_instances.json")

  vars = {
    account_id   = local.account_id
    dbidentifier = aws_db_instance.cporacle.id
  }
}

resource "null_resource" "cporacle_describe_db_instances_rendered" {
  triggers = {
    json = data.template_file.cporacle_describe_db_instances.rendered
  }
}

resource "aws_iam_policy" "cporacle_describe_db_instances" {
  name        = "cporacle-describe-db-instances"
  path        = "/"
  description = "Allows CPOracle EC2 to get RDS endpoint address"
  policy      = data.template_file.cporacle_describe_db_instances.rendered
}

resource "aws_iam_role_policy_attachment" "cporacle_describe_db_instances" {
  policy_arn = aws_iam_policy.cporacle_describe_db_instances.arn
  role       = local.ec2_instance_role_name
}
