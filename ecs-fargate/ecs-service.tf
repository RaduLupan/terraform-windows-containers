# Security group associated with the container.
resource "aws_security_group" "main" {
  name        = "ecs-container-sg"
  description = "Allow inbound traffic"
  vpc_id      = local.vpc_id

  tags = local.common_tags
}

resource "aws_security_group_rule" "container_inbound" {
  type              = "ingress"
  description       = "Container Inbound"
  security_group_id = aws_security_group.main.id

  from_port   = var.container_port
  to_port     = var.container_port
  protocol    = "tcp"
  cidr_blocks = [local.vpc_cidr]
}

# Create separate security rule for health_check only if health_check_port is different than container_port.
resource "aws_security_group_rule" "health_check_inbound" {
  count = var.container_port == var.health_check_port ? 0 : 1

  type              = "ingress"
  description       = "Health Check Inbound"
  security_group_id = aws_security_group.main.id

  from_port   = var.health_check_port
  to_port     = var.health_check_port
  protocol    = "tcp"
  cidr_blocks = [local.vpc_cidr]
}

# Allows all outbound requests. 
resource "aws_security_group_rule" "ecs_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.main.id

  from_port   = local.any_port
  to_port     = local.any_port
  protocol    = local.any_protocol
  cidr_blocks = local.all_ips
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
  requires_compatibilities = ["FARGATE"]
  
  network_mode             = "awsvpc"
  task_role_arn            = aws_iam_role.execution.arn
  
  # Fargate requires operating_system_family be set to a valid option (https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#runtime-platform)
  runtime_platform {
    operating_system_family = "WINDOWS_SERVER_2019_CORE"
  }

  # Fargate requires task definition to have execution role ARN to support log driver awslogs.
  execution_role_arn = aws_iam_role.execution.arn

  # Fargate requires cpu (number of cpu units used by the task) and memory (amount in MiB of memory used by the task). 
  cpu    = var.task_cpu_units
  memory = var.task_memory_mb
   
  container_definitions    = data.template_file.container_definition.rendered
}

# ECS service.
resource "aws_ecs_service" "main" {
  name            = "${var.app_name}-service"
  cluster         = aws_ecs_cluster.main.arn
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = var.desired_count
  
  capacity_provider_strategy {
    base = 1
    weight = 100
    capacity_provider = "FARGATE"
  }
  
  # Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown. Only valid for services configured to use load balancers.
  health_check_grace_period_seconds = 180

  load_balancer {
    target_group_arn = aws_lb_target_group.http.arn
    container_name   = var.app_name
    container_port   = var.container_port
  }

  network_configuration {
    subnets = var.private_subnets
    security_groups = [aws_security_group.main.id]
  }
}
