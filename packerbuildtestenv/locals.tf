locals {

  ec2_props = {
    ami_id                = "ami-07c04e88f232dc18a"
    instance_type         = "t3.large"
    ebs_volume_size       = 120
    ec2_instance_profile  = "alf-packer-builds-role"
    ssh_deployer_key      = "tf-eu-west-2-hmpps-eng-dev-ssh-key"
  }

  subnet_ids = [
    "subnet-00982fba28419ac5f",
    "subnet-0e1b79d45c1e584f2",
    "subnet-0dd9ccbd3ed802151"
  ]

  security_groups = [
    "sg-05844e029b9905498",
    "sg-0a9b8d494576a40d5"
  ]

}