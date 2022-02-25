# Use this dat source to get the vpc_id from the first subnet id provided in the private_subnets variable.
data "aws_subnet" "selected" {
  id = var.private_subnets[0]
}

# Use this data source to retrieve info about a VPC based on its id.
data "aws_vpc" "selected" {
  id = local.vpc_id
}