resource "aws_subnet" "private-us-east-1a" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.0.0/19"
  availability_zone = "us-east-1a"

  tags = {
    "Name"                                                                 = "${var.vpc_subnet_prefix}-${var.eks_env}-${var.eks_tier}-prv-us-east-1a" #"${vpc_subnet_prefix}-${var.env}-sarasa"
    "kubernetes.io/role/internal-elb"                                      = "1"
    "kubernetes.io/cluster/${var.eks_name}-${var.eks_env}-${var.eks_tier}" = "owned"
  }
}

resource "aws_subnet" "private-us-east-1b" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.32.0/19"
  availability_zone = "us-east-1b"

  tags = {
    "Name"                                                                      = "${var.vpc_subnet_prefix}-${var.eks_env}-${var.eks_tier}-prv-us-east-1b"
    "kubernetes.io/role/internal-elb"                                           = "1"
    "kubernetes.io/cluster/${var.eks_name}-${var.eks_env}-${var.eks_tier}"      = "owned"
  }
}

resource "aws_subnet" "public-us-east-1a" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.64.0/19"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    "Name"                                                                  = "${var.vpc_subnet_prefix}-${var.eks_env}-${var.eks_tier}-pub-us-east-1a"
    "kubernetes.io/role/elb"                                                = "1"
    "kubernetes.io/cluster/${var.eks_name}-${var.eks_env}-${var.eks_tier}"  = "owned"
  }
}

resource "aws_subnet" "public-us-east-1b" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.96.0/19"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    "Name"                                                                  = "${var.vpc_subnet_prefix}-${var.eks_env}-${var.eks_tier}-pub-us-east-1b"
    "kubernetes.io/role/elb"                                                = "1"
    "kubernetes.io/cluster/${var.eks_name}-${var.eks_env}-${var.eks_tier}"  = "owned"
  }
}

