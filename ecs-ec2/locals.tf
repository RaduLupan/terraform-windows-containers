locals {
  vpc_id   = data.aws_subnet.selected.vpc_id
  vpc_cidr = data.aws_vpc.selected.cidr_block
  
  ami_id                = var.ami_id == null ? data.aws_ami.win2022_ecs[0].id : var.ami_id
  count_ami_win2022_ecs = var.ami_id == null ? 1 : 0

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

# Use this data source to get the latest AMI Id for a Windows Server 2022 ECS-optimized instance.
data "aws_ami" "win2022_ecs" {
  count = local.count_ami_win2022_ecs

  most_recent = true

  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Core-ECS_Optimized*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}
