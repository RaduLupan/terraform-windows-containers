# Create ECS cluster.
resource "aws_ecs_cluster" "main" {
  name = local.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = local.common_tags
}

# Specify capacity provider and strategy.
resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name
  
  capacity_providers = [aws_ecs_capacity_provider.first.name]
  
  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.first.name
  }
}

# Create ECS capacity provider.
resource "aws_ecs_capacity_provider" "first" {
  name = "asg-capacity-provider-1"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.main.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = 2
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      
      #  Best effort basis, for example, a value of 100 will result in the EC2 instances in the ASG being completely
      #  utilized and any instances not running any tasks will be scaled in, but this behavior is not guaranteed at all times.
      target_capacity           = 100
    }
  }
}