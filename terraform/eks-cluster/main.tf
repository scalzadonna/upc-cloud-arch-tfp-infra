
data "aws_availability_zones" "available" {}

locals {
  vpc_name = "upc-tfp-vpc"
  cluster_name = "upc-tfp-eks-dev"
  cluster_main_node_group_name = "upc-tfp-cluster-one"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = local.vpc_name

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
    ami_type = var.eks_node_group_ami_type
  }

  eks_managed_node_groups = {
    one = {
      name = local.cluster_main_node_group_name

      instance_types = var.eks_node_group_instance_type

      create_iam_role = false
      iam_role_arn = "arn:aws:iam::369651785831:role/LabRole"

      min_size     = var.eks_node_group_min_size
      max_size     = var.eks_node_group_max_size
      desired_size = var.eks_node_group_desired_size
    }

    
  }
}
    

