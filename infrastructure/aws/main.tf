provider "aws" {
  region = var.aws_region
}

# 1. The Networking Foundation (VPC)
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "hotel-federation-vpc"
  cidr = "10.0.0.0/16"

  # Spreading across 3 AZs for High Availability
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  
  # Public Subnets: For the Application Load Balancer
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  
  # Private Subnets: For Apollo Router, NestJS Subgraphs, and Kafka
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  # Database Subnets: Isolated layer for PostgreSQL (RDS)
  database_subnets = ["10.0.201.0/24", "10.0.202.0/24", "10.0.203.0/24"]

  # NAT Gateway: Allows private services to reach Snowflake/GitHub
  enable_nat_gateway = true
  single_nat_gateway = true # Cost-optimization for the demo

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = "production"
    Project     = "Hotel-Federation"
    ManagedBy   = "Terraform"
  }
}

# 2. Security Group for the Load Balancer (Public)
resource "aws_security_group" "alb_sg" {
  name        = "hotel-alb-sg"
  description = "Allow HTTP inbound"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Security Group for the Backend Services (Private)
resource "aws_security_group" "backend_sg" {
  name        = "hotel-backend-sg"
  description = "Allow traffic from ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "GraphQL Traffic from ALB"
    from_port       = 4000
    to_port         = 4000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}