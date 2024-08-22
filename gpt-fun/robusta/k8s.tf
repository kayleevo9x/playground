resource "helm_release" "robusta" {
  name             = "robusta"
  namespace        = "robusta"
  create_namespace = true
  repository       = "https://robusta-charts.storage.googleapis.com"
  chart            = "robusta"
  timeout          = 3600
  values           = [file("${path.module}/templates/generated_values.yaml")]
}