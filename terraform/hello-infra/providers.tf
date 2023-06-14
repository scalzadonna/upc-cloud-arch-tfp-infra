terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    region = "us-east-1"
  }

  required_version = ">= 1.1.5"
}

provider "aws" {
  region = var.region
} 

  
