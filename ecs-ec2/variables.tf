#----------------------------------------------------------------------------
# REQUIRED PARAMETERS: You must provide a value for each of these parameters.
#----------------------------------------------------------------------------

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "private_subnets" {
  description = "The list of private subnets ids where to use for the ECS cluster"
  type        = list(string)
}

#---------------------------------------------------------------
# OPTIONAL PARAMETERS: These parameters have resonable defaults.
#---------------------------------------------------------------

variable "environment" {
  description = "Environment i.e. dev, test, stage, prod"
  type        = string
  default     = "dev"
}

variable "ami_id" {
  description = "The id for the ECS-Optimized Windows AMI to use"
  type        = string
  default     = "ami-0370f2bebfe35bd88"
}

variable "instance_type" {
  description = "The EC2 instance type to use for the container instances"
  type        = string
  default     = "t3.medium"
}
variable "project" {
  description = "The name of the project"
  type        = string
  default     = "ecs-windows-poc"
}
