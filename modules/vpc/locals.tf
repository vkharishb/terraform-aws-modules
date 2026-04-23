data "aws_availability_zones" "available" {}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)

  public_subnets = [
    for i in range(var.az_count) :
    cidrsubnet(var.cidr_block, 8, i)
  ]

  private_subnets = [
    for i in range(var.az_count) :
    cidrsubnet(var.cidr_block, 8, i + 10)
  ]

  common_tags = merge(
    {
      Project     = var.name
      ManagedBy   = "Terraform"
      Environment = "dev"
    },
    var.tags
  )
}