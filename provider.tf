# Terraformプロバイダー設定
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.4.0"
    }
  }
}

# AWSプロバイダー設定
provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      service     = var.service
      environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
} 