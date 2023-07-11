data "aws_eks_cluster" "this" {  name = aws_eks_cluster.eks_cluster.name }
data "aws_eks_cluster_auth" "this" { name = data.aws_eks_cluster.this.name }

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.2.0"
    } 
  }

  backend "s3" {
    region = "us-east-1"
    key    = "tf-upc-tfp-eks-cluster"
  }

  required_version = ">= 1.4.5"
}

provider "aws" {
  region = var.region
} 

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    token                  = data.aws_eks_cluster_auth.this.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
  }
}
