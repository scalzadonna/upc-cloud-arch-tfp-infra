variable "region" {
  default = "us-east-1"
}

variable eks_env {
  default = "dev"
}

variable eks_tier {
  default = "two"
}

variable eks_name {
  default = "upc-tfp-eks"
}

variable vpc_name {
  default = "upc-tfp-vpc"
}

variable vpc_subnet_prefix {
  default = "upc-tfp"
}

variable igw_name {
  default = "upc-tfp-igw"
}

variable nat_name {
  description = ""
  default = "upc-tfp-nat"
}

variable vpc_cidr {
  default = "10.0.0.0/16"
}

variable domain {
  default = "upc-tfp-eks.platform-core.com"
}

variable role_name {
  default = "LabRole"
}

variable eks_nodegroup_name {
  default = "ng-pub"
}

variable eks_nodes_capacity_type {
  default = "ON_DEMAND"
}
variable eks_nodes_instance_type {
  default = "t3.large"
}

variable eks_nodegroup_min_size {
  default = 1
}

variable eks_nodegroup_desired_size {
  default = 1
}

variable eks_nodegroup_max_unavail {
  default = 1
}

variable eks_nodegroup_max_size {
  default = 1
}