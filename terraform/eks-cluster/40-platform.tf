resource "helm_release" "platform-core" {
  name       = "platform-core"
  #chart      = "./platform-core"
  chart      = "../../helm/argocd/platform-core"

  depends_on = [helm_release.crossplane]

}