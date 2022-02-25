# Create launch configuration for the AutoScaling Group
resource "aws_launch_configuration" "launch_config" {
  name          = "asg_launch_config"
  image_id      = var.ami_id
  instance_type = var.instance_type

  lifecycle {
    create_before_destroy = true
  }
}