variable "name_prefix" {
  type        = string
  description = "ALB name prefix"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs"
}

variable "security_groups" {
  type        = list(string)
  description = "Security group IDs"
}

variable "lb_type" {
  type        = string
  default     = "application"
  description = "Load balancer type"
}

variable "internal" {
  type        = bool
  default     = false
  description = "Whether ALB is internal"
}

variable "http_listeners" {
  type = list(object({
    port        = number
    protocol    = string
    action_type = string
    redirect    = optional(map(string))
  }))
  default = []
}

/*variable "https_listeners" {
  type = list(object({
    port               = number
    protocol           = string
    certificate_arn    = string
    ssl_policy         = optional(string)
    target_group_index = optional(number)
  }))
  default = []
}*/

variable "target_groups" {
  type = list(object({
    name_prefix      = string
    backend_protocol = string
    backend_port     = number
    target_type      = string
    health_check     = map(string)
  }))
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags"
}


