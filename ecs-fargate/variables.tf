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

variable "health_check_port" {
  description = "The health check port"
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

variable "project" {
  description = "The name of the project"
  type        = string
  default     = "windows-fargate"
}

variable "tls_cert_arn" {
  description = "The arn of the TLS certificate in ACM to use on the ALB. If null no HTTPS listener will be created."
  type        = string
  default     = null
}

variable "health_check_interval" {
  description = "The approximate amount of time, in seconds, between health checks of an individual target: 5-300"
  type        = string
  default     = "30"
}

variable "health_check_timeout" {
  description = "The amount of time, in seconds, during which no response means a failed health check: 2-120"
  type        = string
  default     = "10"
}

variable "health_check_unhealthy_threshold" {
  description = "The number of consecutive health check failures required before considering a target unhealthy: 2-10"
  type        = string
  default     = "2"
}

variable "health_check_healthy_threshold" {
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy.: 2-10"
  type        = string
  default     = "3"
}

variable "health_check_path" {
  description = "Use the default path of / to ping the root, or specify a custom path if preferred."
  type        = string
  default     = "/"
}
