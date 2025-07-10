resource "aws_ecs_cluster" "main" {
  name = "${var.environment}-${var.cluster_name}"
  tags = var.tags
}

# ECS Task Definition and Service Configuration
# This module creates an ECS task definition and service for running a containerized application on AWS ECS Fargate.
# It includes the task definition, service configuration, and security group setup.
resource "aws_ecs_task_definition" "app" {
  family                   = "${var.service_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  # Define the container definitions for the task
  # Using jsonencode to convert the list of maps to a JSON string
  container_definitions = jsonencode([{
    name      = var.service_name
    image     = "${var.container_image}:${var.container_tag}"
    cpu       = var.task_cpu
    memory    = var.task_memory
    essential = true
    portMappings = [{
      containerPort = var.container_port
      hostPort      = var.container_port
    }]
   environment = flatten([
  for _, env_group in var.container_environment : [
    for k, v in env_group : {
      name  = k
      value = tostring(v)
    }
  ]
])



    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/${var.service_name}"
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])

  tags = var.tags
}

resource "aws_ecs_service" "main" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs_service.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.service_name
    container_port   = var.container_port
  }

  dynamic "capacity_provider_strategy" {
    for_each = var.enable_autoscaling ? [1] : []
    content {
      capacity_provider = "FARGATE_SPOT"
      weight            = 100
    }
  }

  tags = var.tags


}

resource "aws_security_group" "ecs_service" {
  name_prefix = "${var.service_name}-sg-"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.service_name}-sg" })
}

resource "aws_cloudwatch_log_group" "ecs_service" {
  name              = "/ecs/${var.service_name}"
  retention_in_days = 7

  tags = var.tags
}
