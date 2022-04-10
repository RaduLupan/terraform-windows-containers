locals {
  vpc_id   = data.aws_subnet.selected.vpc_id
  vpc_cidr = data.aws_vpc.selected.cidr_block
  
  cluster_name = "${local.common_tags["Project"]}-cluster"

  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]

  ports_source_map = {
    "443"  = "0.0.0.0/0"
    "80"   = "0.0.0.0/0"
  }

  region= data.aws_region.current.name

  common_tags = {
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# Obtain the name of the AWS region configured on the provider.
data "aws_region" "current" {}

