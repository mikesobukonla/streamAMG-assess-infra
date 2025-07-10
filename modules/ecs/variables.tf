variable "vpc_id" {
  type        = string
  description = "VPC ID where ECS will be deployed"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for ECS tasks"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs for load balancers"
}

variable "cluster_name" {
  type        = string
  description = "Base name for ECS cluster"
  default     = "streamamg-cluster"
}

variable "service_name" {
  type        = string
  description = "Name of the ECS service"
  default     = "streamamg-api"
}

variable "container_image" {
  type        = string
  description = "Container image URI"
  default     = "public.ecr.aws/nginx/nginx" # Default test image
}

variable "container_tag" {
  type        = string
  description = "Container image tag"
  default     = "latest"
}

variable "container_port" {
  type        = number
  description = "Port exposed by the container"
  default     = 8080
}

variable "task_cpu" {
  type        = number
  description = "CPU units for task"
  default     = 512 # 0.5 vCPU
}

variable "task_memory" {
  type        = number
  description = "Memory (MB) for task"
  default     = 1024 # 1GB
}

variable "desired_count" {
  type        = number
  description = "Initial number of tasks"
  default     = 1
}

variable "enable_autoscaling" {
  type        = bool
  description = "Enable auto-scaling"
  default     = false
}

variable "target_group_arn" {
  description = "Target Group ARN for ECS service"
  type        = string
}


variable "alb_security_group_id" {
  type        = string
  description = "ALB security group ID"
}

variable "container_environment" {
  description = "Environment variables passed to the ECS container"
  type        = list(map(string))
  default     = []
}


variable "environment" {
  type        = string
  description = "Deployment environment"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
  default     = {}
}

variable "execution_role_arn" {
  description = "IAM role ARN for ECS task execution"
  type        = string
}

variable "task_role_arn" {
  description = "IAM role ARN for ECS task"
  type        = string
}



