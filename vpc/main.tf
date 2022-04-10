provider "aws" {
  region = var.region
}

locals {
  # If there are more than 3 AZs in the region use only 3 otherwise use 2 which is the minimum AZ count in an AWS region.
  az_count      = length(data.aws_availability_zones.available.names) >= 3 ? 3 : 2
  azs           = slice(local.zone_ids_list, 0, local.az_count)
  zone_ids_list = data.aws_availability_zones.available.zone_ids

  # cidrsubnet() function creates a Cidr address in the VpcCidr https://www.terraform.io/docs/configuration/functions/cidrsubnet.html.
  public_subnets  = [cidrsubnet(var.vpc_cidr, 8, 0), cidrsubnet(var.vpc_cidr, 8, 1), cidrsubnet(var.vpc_cidr, 8, 2)]
  private_subnets = [cidrsubnet(var.vpc_cidr, 8, 10), cidrsubnet(var.vpc_cidr, 8, 11), cidrsubnet(var.vpc_cidr, 8, 12)]

  common_tags = {
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# Use this data source to get the list of AWS Availability Zones which can be accessed by an AWS account within the region configured in the provider.
data "aws_availability_zones" "available" {
  state = "available"
}

# Invoke the vpc module from Terraform Registry and create a simple VPC with public and private subnets and a single NAT Gateway serving all private subnets. 
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name = "${var.project}-${var.environment}-vpc"
  cidr = var.vpc_cidr

  azs             = local.azs
  public_subnets  = slice(local.public_subnets, 0, local.az_count)
  private_subnets = slice(local.private_subnets, 0, local.az_count)

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.common_tags
}
