resource "aws_eks_node_group" "eks-ng" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.eks_name}-${var.eks_env}-${var.eks_tier}-${var.eks_nodegroup_name}"
  node_role_arn   = local.labrole_arn

  subnet_ids = [
    aws_subnet.private-us-east-1a.id,
    aws_subnet.private-us-east-1b.id
  ]

  capacity_type  = var.eks_nodes_capacity_type
  instance_types = [var.eks_nodes_instance_type]

  scaling_config {
    min_size     = var.eks_nodegroup_min_size
    desired_size = var.eks_nodegroup_desired_size
    max_size     = var.eks_nodegroup_max_size
    
  }

  update_config {
    max_unavailable = var.eks_nodegroup_max_unavail
  }

}
