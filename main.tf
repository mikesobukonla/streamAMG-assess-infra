module "vpc" {
  source = "./modules/vpc"

  # Required Variables
  environment          = var.environment
  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  tags                 = var.tags
}

module "security_groups" {
  source = "./modules/security-groups"

  vpc_id      = module.vpc.vpc_id
  environment = var.environment
  tags        = var.tags

  depends_on = [module.vpc]
}

# Reference in ALB module
# Application Infrastructure
module "alb" {
  source = "./modules/alb"

  name_prefix     = "streamamg-alb"
  environment     = var.environment
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.public_subnets
  security_groups = [module.security_groups.alb_security_group_id]


 # Remove or comment out the HTTPS listener block

  http_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "forward"
      target_group_index = 0
    }
  ]

  # https_listeners = [ ... ]  <-- not needed

  target_groups = [
    {
      name_prefix      = "api-"
      backend_protocol = "HTTP"
      backend_port     = var.container_port
      target_type      = "ip"
      health_check = {
        path                = "/health"
        interval            = "30"
        healthy_threshold   = "3"
        unhealthy_threshold = "3"
        timeout             = "5"
        matcher             = "200-299"
      }
    }
  ]

  tags = var.tags
}
module "ecs_iam" {
  source = "./modules/ecs-iam"

  tags = var.tags
}


module "ecs" {
  source = "./modules/ecs"

  environment         = var.environment
  vpc_id              = module.vpc.vpc_id
  aws_region          = var.aws_region
  container_image     = var.container_image
  container_tag       = var.container_tag
  container_port      = var.container_port
  service_name        = var.service_name
  cluster_name        = var.cluster_name
  desired_count       = var.desired_count
  task_cpu            = var.task_cpu
  task_memory         = var.task_memory
  target_group_arn    = module.alb.target_group_arn
  alb_security_group_id = module.security_groups.alb_security_group_id
  public_subnet_ids     = module.vpc.public_subnets
  private_subnet_ids    = module.vpc.private_subnets

  execution_role_arn   = module.ecs_iam.ecs_execution_role_arn
  task_role_arn        = module.ecs_iam.ecs_task_role_arn

  container_environment = var.container_environment

  tags = var.tags

    depends_on = [
    module.vpc,
    module.alb,
    
  ]
}

