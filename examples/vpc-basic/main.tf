provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
 source = "git::https://github.com/vkharishb/terraform-aws-modules.git?ref=main"


  name = "demo-vpc"
  cidr_block = var.cidr

  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_flow_logs = false

  tags = {
    Environment = "dev"
    Project     = "terraform-learning"
  }
}