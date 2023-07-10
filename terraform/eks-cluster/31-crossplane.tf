resource "kubernetes_namespace" "crossplane_namespace" {
  metadata {
    name = "crossplane-system"
  }
}

resource "helm_release" "crossplane" {
  name       = "crossplane"
  repository = "https://charts.crossplane.io/stable"
  chart      = "crossplane"
  namespace  = kubernetes_namespace.crossplane_namespace.metadata[0].name

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "rbac.create"
    value = "true"
  }
  depends_on = [kubernetes_namespace.crossplane_namespace, helm_release.argocd]
}

resource "null_resource" "kubectl_aws_secret_crossplane" {
  provisioner "local-exec" {
   command = <<EOT
      kubectl create secret generic aws-secret -n crossplane-system \
      --from-literal=aws_access_key_id=$AWS_ACCESS_KEY_ID \
      --from-literal=aws_secret_access_key=$AWS_SECRET_ACCESS_KEY \
      --from-literal=aws_session_token=$AWS_SESSION_TOKEN
    EOT
  }
  depends_on = [helm_release.crossplane]
}