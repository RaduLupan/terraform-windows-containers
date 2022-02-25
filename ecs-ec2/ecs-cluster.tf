resource "aws_ecs_cluster" "ecs_windows" {
  name = "${local.common_tags["Project"]}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = local.common_tags
}
