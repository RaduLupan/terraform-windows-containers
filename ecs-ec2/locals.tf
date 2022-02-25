locals {
  vpc_id   = data.aws_subnet.selected.vpc_id
  vpc_cidr = data.aws_vpc.selected.cidr_block
  
  cluster_name = "${local.common_tags["Project"]}-cluster"

  common_tags = {
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}
