# Security group associated with the container.
resource "aws_security_group" "main" {
  name        = "ecs-container-sg"
  description = "Allow inbound traffic"
  vpc_id      = local.vpc_id

  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = [local.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

# CloudWatch log group.
resource "aws_cloudwatch_log_group" "lg" {
  name = "/ecs/${var.project}-${var.environment}"

  retention_in_days = 90

  tags = local.common_tags
}

# Use this data set to replace embedded scripts with scripts that sit on different source.
data "template_file" "container_definition" {
  template = file("${path.module}/container-definition.json.tpl")

  vars = {
    app_name       = var.app_name
    app_image      = var.app_image
    container_port = var.container_port
    host_port      = var.host_port
    app_protocol   = var.app_protocol
    app_command    = var.app_command
    app_memory     = var.task_memory_mb
    app_cpu        = var.task_cpu_units
    log_group      = aws_cloudwatch_log_group.lg.name
    region         = local.region
    stream_prefix  = var.project
  }
}

# Task definition.
resource "aws_ecs_task_definition" "main" {
  family                   = "${var.app_name}-task"
  requires_compatibilities = ["EC2"]
  task_role_arn            = aws_iam_role.execution.arn
  container_definitions    = data.template_file.container_definition.rendered
}

# ECS service.
resource "aws_ecs_service" "main" {
  name            = "${var.app_name}-service"
  cluster         = aws_ecs_cluster.main.arn
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = var.desired_count
  
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  capacity_provider_strategy {
    base = 1
    weight = 100
    capacity_provider = aws_ecs_capacity_provider.first.name
  }
  
  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = var.app_name
    container_port   = var.container_port
  }

}