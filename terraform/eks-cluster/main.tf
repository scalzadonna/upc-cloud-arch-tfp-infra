
data "aws_availability_zones" "available" {}

locals {
  cluster_name = "upc-tfp-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 4
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = "upc-tfp-vpc"

  cidr = var.cidr
  azs  = slice(data.aws_availability_zones.available.names, 0, 2)

  private_subnets = var.private_subnets_cidrs
  public_subnets  = var.private_subnets_cidrs

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.5.1"

  cluster_name    = local.cluster_name
  cluster_version = "1.23"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name = "main-node-group"

      instance_types = var.eks_node_group_instance_type

      min_size     = var.eks_node_group_min_size
      max_size     = var.eks_node_group_max_size
      desired_size = var.eks_node_group_desired_size
    }

    
  }
}
    

