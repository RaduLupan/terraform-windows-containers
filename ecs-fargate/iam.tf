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
