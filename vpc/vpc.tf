data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.0"

  name = "${var.project}-${var.environment}-vpc"
  cidr = var.vpc_cidr

  azs             = local.azs
  public_subnets  = slice(local.public_subnets, 0, local.az_count)
  private_subnets = slice(local.private_subnets, 0, local.az_count)

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.common_tags
}
