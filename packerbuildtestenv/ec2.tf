
data "template_file" "instance_userdata" {
  template = file("./userdata/userdata.tpl")
}

resource "null_resource" "userdata_rendered" {
  triggers = {
    json = data.template_file.instance_userdata.rendered
  }
}

resource "aws_instance" "packer_server" {

  ami           = local.ec2_props["ami_id"]
  instance_type = local.ec2_props["instance_type"]

  subnet_id                   = local.subnet_ids[0]
  iam_instance_profile        = local.ec2_props["ec2_instance_profile"]

  associate_public_ip_address = false
  vpc_security_group_ids      = local.security_groups
  
  key_name = local.ec2_props["ssh_deployer_key"]

  root_block_device {
    volume_size = local.ec2_props["ebs_volume_size"]
  }

  monitoring = false

  user_data = data.template_file.instance_userdata.rendered

  lifecycle {
    ignore_changes = [
      ami,
      user_data,
      instance_type
    ]
  }

  tags = {
    "Name" = "packer-test"
  }
}
