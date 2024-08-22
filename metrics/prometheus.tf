resource "helm_release" "prometheus-stack" {
  name             = "prometheus"
  namespace        = "monitoring"
  create_namespace = true
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "61.7.1"
  timeout          = 900
  values           = [file("${path.module}/templates/prometheus/values.yaml")]

}
