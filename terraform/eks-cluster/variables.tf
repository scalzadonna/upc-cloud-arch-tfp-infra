variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cidr" {
  description = "EKS Cluster default CIDR block"
  type = string 
  default = "10.0.0.0/16"
}

variable "public_subnets_cidrs" {
  description = "EKS Cluster public subnets default CIDRs"
  type = list
  default = ["10.0.16.0/24", "10.0.17.0/24"]
}

variable "private_subnets_cidrs" {
  description = "EKS Cluster public subnets default CIDRs"
  type = list
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "eks_node_group_instance_type" {
  description = "Default EKS node group instance type"
  type = list
  default = ["t3.medium"]
}

variable "eks_node_group_min_size" {
  description = "Default EKS node group min size"
  type = number
  default = 1
}

variable "eks_node_group_max_size" {
  description = "Default EKS node group max size"
  type = number
  default = 3
}

variable "eks_node_group_desired_size" {
  description = "Default EKS node group desired size"
  type = number
  default = 2
}