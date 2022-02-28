locals {
  vpc_id   = data.aws_subnet.selected.vpc_id
  vpc_cidr = data.aws_vpc.selected.cidr_block
  
  cluster_name = "${local.common_tags["Project"]}-cluster"

  region= data.aws_region.current.name

  common_tags = {
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# Obtain the name of the AWS region configured on the provider.
data "aws_region" "current" {}