module "eks" {
  source = "git::https://github.com/vkharishb/terraform-aws-modules.git//modules/eks?ref=main"
  #source = "../../modules/eks"

  cluster_name    = "demo-eks"
  cluster_version = "1.29"

  subnet_ids = module.vpc.private_subnets

  cluster_role_arn = module.iam.cluster_role_arn
  node_role_arn    = module.iam.node_role_arn
}

module "vpc" {
  source = "git::https://github.com/vkharishb/terraform-aws-modules.git//modules/vpc?ref=main"
  #source = "../../modules/vpc"

  name = "demo-vpc"
  cidr_block = var.cidr_block

   tags = {
    Environment = "dev"
  }
}

module "iam" {
  source = "git::https://github.com/vkharishb/terraform-aws-modules.git//modules/iam-eks?ref=main"
  #source = "../../modules/iam-eks"

  cluster_name = "demo-eks"

  tags = {
    Environment = "dev"
  }
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}