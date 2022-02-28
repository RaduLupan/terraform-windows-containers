#----------------------------------------------------------------------------
# REQUIRED PARAMETERS: You must provide a value for each of these parameters.
#----------------------------------------------------------------------------

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "private_subnets" {
  description = "The list of private subnets ids to use for the ECS cluster"
  type = list(string)
}

variable "public_subnets" {
  description = "The list of public subnets ids to use for the load balancer"
  type = list(string)
}

variable "host_port" {
  description = "The port exposed by the container host"
  type        = number
}

variable "container_port" {
  description = "The port exposed by the container"
  type        = number
}

variable "app_name" {
  description = "The name of the container app"
  type        = string
}

variable "app_image" {
  description = "The image URI:tag in the ECR/MCR registry"
  type        = string
}

variable "app_protocol" {
  description = "The transport protocol used by the container app (tcp or udp)"
  type        = string
}

variable "app_command" {
    description = "Container command"
    type        = string
}

variable "task_memory_mb" {
  description = "Memory allocated to a task in MB"
  type        = number
}

variable "task_cpu_units" {
  description = "CPU units allocated to a task"
  type        = number
}

variable "desired_count" {
  description = "The desired number of tasks"
  type        = number
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
