# Use this data set to replace embedded bash scripts such as user_data with scripts that sit on different source.
data "template_file" "user_data" {
  template = file("${path.module}/user-data.ps1")

  vars = {
    ecs_cluster = local.cluster_name
  }
}

# Security group for the AutoScaling Group launch configuration.
resource "aws_security_group" "launch_config" {
  name        = "ecs-instance-sg"
  description = "Allow inbound traffic"
  vpc_id      = local.vpc_id

  ingress {
    from_port   = var.host_port
    to_port     = var.host_port
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
resource "aws_launch_configuration" "windows" {
  #name          = "asg-launch-config"
  image_id      = var.ami_id
  instance_type = var.instance_type
  
  security_groups      = [aws_security_group.launch_config.id]
  iam_instance_profile = aws_iam_instance_profile.main.name

  user_data       = data.template_file.user_data.rendered

  lifecycle {
    create_before_destroy = true
  }
}

# Create AutoScaling Group for infrastructure.
resource "aws_autoscaling_group" "main" {
  name                 = "${local.common_tags["Project"]}-${var.environment}-asg"
  launch_configuration = aws_launch_configuration.windows.name

  vpc_zone_identifier = var.private_subnets

  min_size         = 0
  max_size         = 10
  desired_capacity = 0

  protect_from_scale_in = true

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${local.common_tags["Project"]}-${var.environment}-instance"
    propagate_at_launch = true
  }

  # Associating an ECS Capacity Provider to an Auto Scaling Group will automatically add the AmazonECSManaged tag to the Auto Scaling Group,
  # therefore the AmazonECSManaged tag needs to be added to ASG in order to prevent Terraform from removing it in subsequent executions.
  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }

  # Dynamically generates inline tag blocks with for_each.
  dynamic "tag" {
    for_each = local.common_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}