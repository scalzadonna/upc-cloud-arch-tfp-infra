data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  labrole_arn = "arn:aws:iam::${local.account_id}:role/${var.role_name}"
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.eks_name}-${var.eks_env}-${var.eks_tier}"
  role_arn = local.labrole_arn

  vpc_config {
    subnet_ids = [
      aws_subnet.private-us-east-1a.id,
      aws_subnet.private-us-east-1b.id,
      aws_subnet.public-us-east-1a.id,
      aws_subnet.public-us-east-1b.id
    ]
  }

  depends_on = [aws_internet_gateway.main_igw]

}

resource "null_resource" "update_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${aws_eks_cluster.eks_cluster.name}"
  }
}
