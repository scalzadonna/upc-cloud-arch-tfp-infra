resource "helm_release" "platform-core" {
  name       = "platform-core"
  #chart      = "./platform-core"
  chart      = "../../helm/argocd/platform-core"

  depends_on = [helm_release.crossplane]
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
  depends_on = [helm_release.platform-core]
}