variable "vpc_id" {
  type        = string
  description = "VPC ID where security groups will be created"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, prod)"
}

variable "tags" {
  type        = map(string)
  description = "Common tags for all resources"
  default     = {}
}