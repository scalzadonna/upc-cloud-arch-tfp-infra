terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.2.0"
    }
  }

  backend "s3" {
    region = "us-east-1"
    bucket = "tf-remote-state20230610104533439800000001"
    dynamodb_table = "tf-remote-state-lock"
    key    = "tf-upc-tfp-eks-cluster"
  }

  required_version = ">= 1.4.5"
}

provider "aws" {
  region = var.region
} 
