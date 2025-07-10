output "cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "service_name" {
  value = aws_ecs_service.main.name
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.app.arn
}

output "security_group_id" {
  value = aws_security_group.ecs_service.id
}

output "ecs_execution_role_arn" {
  description = "IAM role ARN used by ECS task execution"
  value       = aws_iam_role.ecs_execution_role.arn
}

output "ecs_task_role_arn" {
  description = "IAM role ARN used by ECS tasks"
  value       = aws_iam_role.ecs_task_role.arn
}

output "container_image" {
  description = "Container image URI used in the ECS task"
  value       = "${var.container_image}:${var.container_tag}" 
  
}



/*
output "alb_target_group_arn" {
  value = module.alb.target_group_arns[0]
}*/