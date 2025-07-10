resource "aws_iam_role" "vpc_flow_logs" {
  name = "${var.environment}-${var.vpc_name}-vpc-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "vpc-flow-logs.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "vpc_flow_logs" {
  name = "vpc-flow-logs-policy"
  role = aws_iam_role.vpc_flow_logs.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      Resource = "*"
    }]
  })
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  # Core Configuration
  name = "${var.environment}-${var.vpc_name}"
  cidr = var.vpc_cidr
  azs  = var.availability_zones

  # Subnets
  public_subnets  = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs

  # NAT Gateway
  enable_nat_gateway = true
  single_nat_gateway = false
  nat_gateway_tags = {
    Name = "${var.environment}-${var.vpc_name}-nat"
  }

  # DNS
  enable_dns_support   = true
  enable_dns_hostnames = true

  # Flow Logs (Requires pre-created CW Log Group)
  enable_flow_log           = true
  flow_log_destination_type = "cloud-watch-logs"
  flow_log_destination_arn  = aws_cloudwatch_log_group.vpc_flow_logs.arn
  flow_log_cloudwatch_iam_role_arn         = aws_iam_role.vpc_flow_logs.arn

  # Tags
  tags = merge(
    var.tags,
    {
      Terraform   = "true"
      Component   = "network"
    }
  )

  public_subnet_tags = merge(
    {
      "kubernetes.io/role/elb" = "1"
    },
    var.public_subnet_tags
  )

  private_subnet_tags = merge(
    {
      "kubernetes.io/role/internal-elb" = "1"
    },
    var.private_subnet_tags
  )
}

# Supporting Resource (Must be declared in same module)
/*
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/aws/vpc/flow-logs/${var.environment}-${var.vpc_name}"
  retention_in_days = 90
  tags = merge(var.tags, { Name = "vpc-flow-logs" })
}
*/

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/aws/vpc/flow-logs/${var.environment}-${var.vpc_name}"
  retention_in_days = 90
  tags = merge(var.tags, { Name = "vpc-flow-logs" })

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [name]
  }
}
