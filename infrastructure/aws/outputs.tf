# 1. Network Identity
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# 2. Subnet IDs for Deployment
output "private_subnets" {
  description = "List of IDs of private subnets for Backend Services"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets for Load Balancer"
  value       = module.vpc.public_subnets
}

# 3. Security Group IDs for Rules
output "alb_security_group_id" {
  description = "The ID of the Security Group for the Load Balancer"
  value       = aws_security_group.alb_sg.id
}

output "backend_security_group_id" {
  description = "The ID of the Security Group for Backend Services"
  value       = aws_security_group.backend_sg.id
}

# 4. Routing Info
output "nat_public_ips" {
  description = "The Public IP of the NAT Gateway (Useful for Snowflake Whitelisting)"
  value       = module.vpc.nat_public_ips
}