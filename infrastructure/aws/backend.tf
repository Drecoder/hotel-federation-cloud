terraform {
  backend "s3" {
    bucket         = "andres-arias-terraform-state" 
    key            = "hotel-federation/vpc/terraform.tfstate"
    region         = "us-east-1"
    
    # This enables state locking via DynamoDB
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}