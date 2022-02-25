# Use this data set to replace embedded bash scripts such as user_data with scripts that sit on different source.
data "template_file" "user_data" {
  template = file("${path.module}/user-data.ps1")

  vars = {
    ecs_cluster = aws_ecs_cluster.ecs_windows.name
  }
}

# Security group for the AutoScaling Group launch configuration.
resource "aws_security_group" "launch_config" {
  name        = "ecs-instance-sg"
  description = "Allow inbound traffic"
  vpc_id      = local.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [local.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "ecs-cluster-instance-sg"
    Environment = var.environment
    Project     = var.project
    Terraform   = true
  }
}

# Create launch configuration for the AutoScaling Group
resource "aws_launch_configuration" "launch_config" {
  #name          = "asg-launch-config"
  image_id      = var.ami_id
  instance_type = var.instance_type

  user_data       = data.template_file.user_data.rendered

  lifecycle {
    create_before_destroy = true
  }
}