data "template_file" "cp_oracle_iam_policy" {
  template = file("policies/cporacle_ec2_iam_policy.json")

  vars = {
    s3-config-bucket = "XXXXXX"
    app_role_arn     = module.iam_role_cp_oracle.iamrole_arn
  }
}

module "iam_role_cp_oracle" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//iam//role?ref=terraform-0.12"
  rolename   = "${local.common_name}-ec2"
  policyfile = "ec2_policy.json"
}

module "iam_instance_profile_cp_oracle" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//iam//instance_profile?ref=terraform-0.12"
  role   = module.iam_role_cp_oracle.iamrole_name
}

module "iam_app_policy_cp_oracle" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//iam//rolepolicy?ref=terraform-0.12"
  policyfile = data.template_file.cp_oracle_iam_policy.rendered
  rolename   = module.iam_role_cp_oracle.iamrole_name
}

resource "aws_iam_role_policy_attachment" "cporacle_instance_cloudwatch_policy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = module.iam_role_cp_oracle.iamrole_name
}

resource "aws_iam_role_policy_attachment" "cporacle_instance_ssmmgmt_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = module.iam_role_cp_oracle.iamrole_name
}

resource "aws_iam_role_policy_attachment" "cporacle_instance_ssm_agent" {
  role       = module.iam_role_cp_oracle.iamrole_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
