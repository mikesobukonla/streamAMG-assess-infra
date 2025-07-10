output "arn" {
  description = "ARN of the ALB"
  value       = module.internal_alb.lb_arn
}

output "dns_name" {
  description = "DNS name of the ALB"
  value       = module.internal_alb.lb_dns_name
}

output "target_group_arns" {
  description = "The ARNs of the ALB target groups"
  value       = module.internal_alb.target_group_arns
}

output "target_group_arn" {
  description = "The first target group ARN"
  value       = module.internal_alb.target_group_arns[0]
}



output "https_listener_arns" {
  description = "ARNs of HTTPS listeners"
  value       = module.internal_alb.https_listener_arns
}
output "alb_arn_suffix" {
  value = module.internal_alb.lb_arn_suffix
  description = "The ARN suffix of the ALB"
}

