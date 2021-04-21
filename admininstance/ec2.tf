
data "template_file" "instance_userdata" {
  count    = local.admin_server_count
  template = file("./userdata/userdata.tpl")

  # vars = {
  #   internal_domain = local.internal_domain
  # }
}

resource "null_resource" "userdata_rendered" {
  triggers = {
    json = data.template_file.instance_userdata[0].rendered
  }
}

# Iteratively create EC2 instances
resource "aws_instance" "admin_server" {
  count         = local.admin_server_count
  ami           = local.ec2_props["ami_id"]
  instance_type = local.ec2_props["instance_type"]

  # element() function wraps if index > list count, so we get an even distribution across AZ subnets
  subnet_id                   = local.private_subnets[count.index]
  iam_instance_profile        = local.ec2_instance_profile
  associate_public_ip_address = false
  vpc_security_group_ids      = local.asg_security_groups
  key_name = local.ssh_deployer_key

  volume_tags = merge(
    {
      "Name" = "${local.hostname}${count.index + 1}"
    },
  )

  tags = merge(
    local.tags,
    {
      # "Name" = "${local.environment_identifier}-${local.app_name}-${local.nart_prefix}${count.index + 1}-fsx"
      "Name" = "${local.hostname}${count.index + 1}"
    },
    {
      "CreateSnapshot" = 0
    },
  )

  monitoring = true

  root_block_device {
    volume_size = local.ec2_props["ebs_volume_size"]
  }

  user_data = element(data.template_file.instance_userdata.*.rendered, count.index)

  lifecycle {
    ignore_changes = [
      ami,
      user_data,
      instance_type
    ]
  }
}
