resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.36.10"
  namespace  = "default"

  provisioner "local-exec" {
    command = "kubectl patch -n default service argocd-server -p '{\"spec\":{\"type\":\"LoadBalancer\"}}'"
  }

  depends_on = [aws_eks_node_group.eks-prv-ng]
}