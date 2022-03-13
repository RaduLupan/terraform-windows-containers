output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "ecs_asg_name" {
  description = "The name of the Auto Scaling Group that handles the ECS cluster infrastructure"
  value       = aws_autoscaling_group.main.name
}

output "ecs_service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.main.name
}

output "ecs_alb_dns_name" {
  description = "The DNS name for the internet-facing Aplication Load Balancer that fronts the ECS service"
  value       = aws_lb.main.dns_name
}
