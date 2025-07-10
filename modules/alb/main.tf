module "internal_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name               = "${var.environment}-${var.name_prefix}"
  load_balancer_type = "application"
  internal           = false
  vpc_id             = var.vpc_id
  subnets            = var.subnet_ids
  security_groups    = var.security_groups

  http_tcp_listeners = var.http_listeners
  # https_listeners is removed

  target_groups = var.target_groups

  tags = merge(
    var.tags,
    {
      Component = "load-balancer"
    }
  )
}
