module "iam" {
  #source = "git::https://github.com/vkharishb/terraform-aws-modules.git//modules/iam-eks?ref=main"
  source = "../../modules/iam-eks"

  cluster_name = "demo-eks"

  tags = {
    Environment = "dev"
    Project     = "eks"
  }
}