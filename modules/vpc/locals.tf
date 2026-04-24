data "aws_availability_zones" "available" {}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)

  public_subnets = length(var.public_subnets) > 0 ? var.public_subnets : [
    for i in range(var.az_count) :
    cidrsubnet(var.cidr_block, 8, i)
  ]

  private_subnets = length(var.private_subnets) > 0 ? var.private_subnets : [
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