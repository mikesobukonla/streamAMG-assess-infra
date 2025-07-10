# ======================
# Global Configuration
# ======================
aws_region  = "eu-west-1"
environment = "dev"

# ======================
# VPC Network
# ======================
vpc_name           = "streamamg-vpc"
vpc_cidr           = "10.0.0.0/16"
availability_zones = ["eu-west-1a", "eu-west-1b"]

public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]

# ======================
# Security
# ======================
public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEoXyRhXe2zMsRsm/yy50PB2EBMxtdGSn0P3EmtWpeKz mike.sobukonla@gmail.com"

api_security_group_rules = {
  https = {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS traffic"
  },
  ssh = {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["203.0.113.42/32"] # Restrict to your IP
    description = "SSH access"
  }
}


# ======================
# ECS Configuration
# ======================
task_cpu              = "512"
task_memory           = "1024"
container_image       = "nginx"
container_tag         = "latest"
service_name          = "my-service"
cluster_name          = "my-cluster"
desired_count         = 2
container_environment = [
  {
    name  = "ENV"
    value = "dev"
  }
]
