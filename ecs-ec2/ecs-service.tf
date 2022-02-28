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