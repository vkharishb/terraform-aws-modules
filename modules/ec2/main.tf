data "aws_ami" "linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_ami" "windows" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }
}

locals {
  ami_id = var.os_type == "linux" ? data.aws_ami.linux.id : data.aws_ami.windows.id

  user_data = var.user_data_enabled ? (
    var.os_type == "linux"
    ? file("${path.module}/user_data/linux.sh")
    : file("${path.module}/user_data/windows.ps1")
  ) : null
}

resource "aws_instance" "this" {
  ami                         = local.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip

  iam_instance_profile = var.iam_instance_profile

  user_data = local.user_data

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }

  tags = merge(var.tags, {
    Name = var.name
    OS   = var.os_type
  })
}