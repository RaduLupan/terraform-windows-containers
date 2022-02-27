# Template file for the task execution role trust policy.
data "template_file" "execution_role_trust" {
  template = file("${path.module}/task-execution-role-trust.json.tpl")
}

# Template file for the task execution role IAM policy.
data "template_file" "execution_role_policy" {
  template = file("${path.module}/task-execution-role-policy.json.tpl")
}

# ECS task execution IAM role.
resource "aws_iam_role" "execution" {
  name = "${var.project}-ecs-execution"
  path = "/"
  
  assume_role_policy = data.template_file.execution_role_trust.rendered

  tags = local.common_tags
}

# IAM policy associated with the task execution role.
resource "aws_iam_role_policy" "main" {
  name = "${var.project}-ecs-policy"
  role = aws_iam_role.execution.id

  policy = data.template_file.execution_role_policy.rendered
}

# Template file for the container instance role trust policy.
data "template_file" "instance_role_trust" {
  template = file("${path.module}/instance-role-trust.json.tpl")
}

# Use this data source to retrieve an AWS managed IAM policy.
data "aws_iam_policy" "AmazonEC2ContainerServiceforEC2Role" {
  name = "AmazonEC2ContainerServiceforEC2Role"
}

data "aws_iam_policy" "AmazonSSMManagedInstanceCore" {
  name = "AmazonSSMManagedInstanceCore"
}

# Container instance IAM role using two AWS managed IAM policies: AmazonEC2ContainerServiceforEC2Role and AmazonSSMManagedInstanceCore.
resource "aws_iam_role" "instance" {
  name                = "${var.project}-ecs-instance"
  assume_role_policy  = data.template_file.instance_role_trust.rendered
  managed_policy_arns = [data.aws_iam_policy.AmazonEC2ContainerServiceforEC2Role.arn, data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn]
}

# Container instance IAM profile.
resource "aws_iam_instance_profile" "main" {
  name = "${var.project}-profile"
  role = aws_iam_role.instance.name
}