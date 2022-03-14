# Use this dat source to get the vpc_id from the first subnet id provided in the private_subnets variable.
data "aws_subnet" "selected" {
  id = var.private_subnets[0]
}

# Use this data source to retrieve info about a VPC based on its id.
data "aws_vpc" "selected" {
  id = local.vpc_id
}

# Create HTTP target group for the ALB in front of the ECS service.
resource "aws_lb_target_group" "http" {
  name     = "${var.project}-http-tg"
  port     = var.host_port
  protocol = "HTTP"
  
  target_type = "ip"
  
  vpc_id   = local.vpc_id

  health_check {
    healthy_threshold   = var.health_check_healthy_threshold
    interval            = var.health_check_interval
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = var.health_check_timeout
    path                = var.health_check_path
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }

  tags = local.common_tags
}

# Create security group for the ECS service ALB.
resource "aws_security_group" "alb" {
  name   = "ecs-service-alb-sg"
  vpc_id = local.vpc_id

  tags = local.common_tags
}   

# Create ingress rules for the ALB security group.
resource "aws_security_group_rule" "ingress" {
  for_each = local.ports_source_map

  type              = "ingress"
  description       = "Inbound TCP ${each.key}"
  security_group_id = aws_security_group.alb.id

  from_port   = each.key
  to_port     = each.key
  protocol    = local.tcp_protocol
  cidr_blocks = [each.value]
}

# Create egress rule for the ALB security group: allow all outbound traffic.
resource "aws_security_group_rule" "alb_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.alb.id

  from_port   = local.any_port
  to_port     = local.any_port
  protocol    = local.any_protocol
  cidr_blocks = local.all_ips
}

# Create ALB for the ECS service.
resource "aws_lb" "main" {
  name               = "${var.project}-${var.environment}-ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnets

  enable_deletion_protection = false

  tags = local.common_tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
}

# Create HTTPS listener if tls_cert_arn is not null.
resource "aws_lb_listener" "front_end" {
  count = var.tls_cert_arn == null ? 0 : 1
  
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.tls_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
}
