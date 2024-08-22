resource "helm_release" "local-ai" {
  name             = "local-ai"
  namespace        = "local-ai"
  create_namespace = true
  repository       = "https://go-skynet.github.io/helm-charts/"
  chart            = "local-ai"
  timeout          = 900
  values           = [file("${path.module}/templates/values.yaml")]
}