provider "aws" {
  region = "ap-south-1"
}

module "ec2" {
  source = "../../modules/ec2"

  name          = "test-ec2"
  ami_id        = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.default.id

  vpc_security_group_ids = [data.aws_security_group.default.id]

  tags = {
    Environment = "test"
    Project     = "terraform-module-test"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default" {
  default_for_az    = true
  availability_zone = "ap-south-1a"
  vpc_id            = data.aws_vpc.default.id
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}