resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.36.10"
  namespace  = "default"

  values = [
    file("${path.module}/argocd.yaml")
  ]

  provisioner "local-exec" {
    command = "kubectl patch -n default service argocd-server -p '{\"spec\":{\"type\":\"LoadBalancer\"}}'"
  }
}