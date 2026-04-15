# 1. Primary Region
variable "aws_region" {
  description = "The AWS region to deploy the hotel federation infrastructure"
  type        = string
  default     = "us-east-1" 
}

# 2. Project Naming
variable "project_name" {
  description = "Project name used for resource tagging and naming conventions"
  type        = string
  default     = "hotel-federation"
}

# 3. Networking Defaults
variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

# 4. Availability Zones
variable "availability_zones" {
  description = "List of availability zones for multi-AZ high availability"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

# 5. Environment Tagging
variable "environment" {
  description = "Deployment environment (e.g., dev, staging, production)"
  type        = string
  default     = "production"
}