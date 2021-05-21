data "template_file" "instance_userdata_api" {

  template = file("userdata/userdata-api.tpl")

  vars = {
    user_ssm_path     = "/${local.environment_name}/cporacle/cporacle_user"
    password_ssm_path = "/${local.environment_name}/cporacle/cporacle_password"
  }
}

resource "null_resource" "cporacle_aws_launch_template_userdata_api_rendered" {
  triggers = {
    json = data.template_file.instance_userdata_api.rendered
  }
}

resource "aws_launch_template" "cporacle_api" {

  name        = local.launch_template_api_name
  description = "Windows CP Oracle API Service Launch Template"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_type = "gp2"
      volume_size = local.cporacle_api_asg_props["ebs_volume_size"]
    }
  }

  update_default_version = true

  ebs_optimized = true

  iam_instance_profile {
    name = local.ec2_instance_profile.iam_instance_name
  }

  image_id      = local.cporacle_api_asg_props["ami_id"]
  instance_type = local.cporacle_api_asg_props["instance_type"]

  vpc_security_group_ids = local.asg_security_groups
  key_name               = local.ssh_deployer_key

  monitoring {
    enabled = true
  }

  # network_interfaces {
  #   associate_public_ip_address = false
  # }

  user_data = base64encode(data.template_file.instance_userdata_api.rendered)

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      local.tags,
      {
        "Name" = "${local.environment_name}-${local.common_name}-ec2-api"
      }
    )

  }

  tag_specifications {
    resource_type = "volume"
    tags = merge(
      local.tags,
      {
        "Name" = "${local.environment_name}-${local.common_name}-ebs-api"
      }
    )
  }

  # lifecycle {
  #   ignore_changes = [
  #     user_data,
  #     name_prefix,
  #   ]
  # }
}

resource "aws_autoscaling_group" "cporacle_api" {

  name = local.asg_api_name

  vpc_zone_identifier = local.private_subnets

  desired_capacity          = 1
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 600
  health_check_type         = "ELB"

  target_group_arns = [local.api_target_group_arn]

  launch_template {
    id      = aws_launch_template.cporacle_api.id
    version = "$Latest"
  }

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

  #   suspended_processes = local.cporacle_asg_suspended_processes

  tags = data.null_data_source.cporacle_api_asg_tags.*.outputs
}


# Hack to merge additional tag into existing map and convert to list for use with asg tags input
data "null_data_source" "cporacle_api_asg_tags" {
  count = length(
    keys(
      merge(
        local.tags,
        {
          "Name" = local.asg_api_name
        },
      ),
    ),
  )

  inputs = {
    key = element(
      keys(
        merge(
          local.tags,
          {
            "Name" = local.asg_api_name
          },
        ),
      ),
      count.index,
    )
    value = element(
      values(
        merge(
          local.tags,
          {
            "Name" = local.asg_api_name
          },
        ),
      ),
      count.index,
    )
    propagate_at_launch = "true"
  }
}