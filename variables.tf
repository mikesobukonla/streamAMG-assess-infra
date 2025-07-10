# ======================
# Global Configurations
# ======================
variable "aws_region" {
  type        = string
  description = "AWS region where resources will be deployed"
  default     = "eu-west-1"

  validation {
    condition     = contains(["eu-west-1", "eu-west-2", "us-east-1"], var.aws_region)
    error_message = "Allowed regions: eu-west-1, eu-west-2, us-east-1."
  }
}

variable "environment" {
  type        = string
  description = "Deployment environment (dev/staging/prod)"
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Valid values: dev, staging, prod."
  }
}

# ======================
# VPC Network
# ======================
variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "11.0.0.0/16"

  validation {
    condition     = can(regex("^10\\.|^172\\.(1[6-9]|2[0-9]|3[0-1])\\.|^192\\.168\\.", var.vpc_cidr))
    error_message = "CIDR must be in RFC 1918 private ranges (10.x, 172.16-31.x, 192.168.x)."
  }
}

variable "vpc_name" {
  type        = string
  description = "Name tag for the VPC"
  default     = "streamamg-vpc"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones for subnets"
  default     = ["eu-west-1a", "eu-west-1b"]

  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "At least 2 AZs required for HA."
  }
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
  default     = ["11.0.1.0/24", "11.0.2.0/24"]

  validation {
    condition     = length(var.public_subnet_cidrs) == length(var.availability_zones)
    error_message = "Number of public subnets must match AZs."
  }
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private subnets"
  default     = ["11.0.3.0/24", "11.0.4.0/24"]

  validation {
    condition     = length(var.private_subnet_cidrs) == length(var.availability_zones)
    error_message = "Number of private subnets must match AZs."
  }
}

# ======================
# Security
# ======================
variable "public_key" {
  type        = string
  description = "SSH public key for EC2 instances"
  sensitive   = true # Marks the variable as sensitive in outputs
}
variable "api_security_group_rules" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  description = "Security group rules for API services"
  default = {
    https = {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTPS from anywhere"
    }
  }
}

# ======================
# Tagging Standards
# ======================
variable "tags" {
  type        = map(string)
  description = "Common tags to apply to all resources"
  default = {
    Project     = "StreamAMG"
    ManagedBy   = "Terraform"
    Environment = "staging" # Default, override in terraform.tfvars
  }
}
# ======================
# ACM Certificate  
# ======================
variable "acm_certificate_arn" {
  type        = string
  description = "ARN of the ACM certificate for HTTPS"
  default     = "" # Consider making this required if you always need HTTPS
}
# ======================
# ECS Configuration 
# ======================

variable "container_port" {
  type        = number
  description = "Port your container listens on"
  default     = 8080 # Set your default app port here
}

variable "task_cpu" {
  description = "The number of CPU units used by the task"
  type        = string
}

variable "task_memory" {
  description = "The amount of memory (in MiB) used by the task"
  type        = string
}

variable "container_image" {
  description = "The name of the Docker container image"
  type        = string
}

variable "container_tag" {
  description = "The Docker image tag"
  type        = string
}

variable "container_environment" {
  description = "Environment variables for the container"
  type        = list(map(string))
  default     = []
}

variable "service_name" {
  description = "The name of the ECS service"
  type        = string
}

variable "cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "desired_count" {
  description = "The desired number of ECS tasks"
  type        = number
}
