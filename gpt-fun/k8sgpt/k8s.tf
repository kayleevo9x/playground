resource "helm_release" "k8sgpt" {
  name             = "k8sgpt"
  repository       = "https://charts.k8sgpt.ai/"
  chart            = "k8sgpt-operator"
  timeout          = 900
  values           = [file("${path.module}/templates/values.yaml")]
}