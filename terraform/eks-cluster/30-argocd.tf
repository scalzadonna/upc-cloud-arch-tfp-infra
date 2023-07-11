resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.36.10"
  namespace  = "default"

  # provisioner "local-exec" {
  #   command = "kubectl patch -n default service argocd-server -p '{\"spec\":{\"type\":\"LoadBalancer\"}}'"
  # }

  depends_on = [aws_eks_node_group.eks-prv-ng]
}

resource "null_resource" "save_admin_pass_secret" {
  provisioner "local-exec" {
    command = <<EOF
      PASS=$(kubectl -n default get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d) &&
      URL=$(kubectl get svc argocd-server --output jsonpath='{.status.loadBalancer.ingress[0].hostname}') &&
      aws secretsmanager create-secret --name $NAME --secret-string "{\"user\":\"$USER\" ,\"password\":\"$PASS\" , \"url\":\"$URL\"}"  > /dev/null
    EOF
    environment = {
      NAME = "${var.eks_name}-${var.eks_env}-${var.eks_tier}"
      USER = "admin"
    }
  }
  depends_on = [helm_release.argocd]
}