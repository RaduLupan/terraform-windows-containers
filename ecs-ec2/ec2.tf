# Use this data set to replace embedded bash scripts such as user_data with scripts that sit on different source.
data "template_file" "user_data" {
  template = file("${path.module}/user-data.ps1")

  vars = {
    ecs_cluster = aws_ecs_cluster.ecs_windows.name
  }
}
# Create launch configuration for the AutoScaling Group
resource "aws_launch_configuration" "launch_config" {
  name          = "asg-launch-config"
  image_id      = var.ami_id
  instance_type = var.instance_type

  lifecycle {
    create_before_destroy = true
  }
}