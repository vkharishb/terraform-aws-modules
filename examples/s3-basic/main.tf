module "s3" {
  #source = "git::https://github.com/vkharishb/terraform-aws-modules.git//modules/s3?ref=main"
  source = "../../modules/s3"

  bucket_name = "harish-demo-eks-state-12345"

  environment = "dev"

  tags = {
    Project = "eks"
  }
}