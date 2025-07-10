variable "environment" {
  type        = string
  description = "Deployment environment (dev/staging/prod)"
}

variable "vpc_name" {
  type        = string
  description = "Base name for VPC resources"
}

variable "vpc_cidr" {
  type        = string
  description = "Primary CIDR block for VPC"
}

variable "availability_zones" {
  type        = list(string)
  description = "AZs for subnets"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDRs for public subnets"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDRs for private subnets"
}

variable "tags" {
  type        = map(string)
  description = "Common tags for all resources"
  default     = {}
}

variable "public_subnet_tags" {
  type        = map(string)
  description = "Additional public subnet tags"
  default     = {}
}

variable "private_subnet_tags" {
  type        = map(string)
  description = "Additional private subnet tags"
  default     = {}
}