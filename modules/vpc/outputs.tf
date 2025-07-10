output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}



/*output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = module.vpc.nat_gateway_id
}*/


# modules/vpc/outputs.tf

/*output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public[*].id
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private[*].id
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}*/