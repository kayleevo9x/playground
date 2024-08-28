resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "argocd" {
  name             = var.name
  namespace        = kubernetes_namespace.this.metadata[0].name
  create_namespace = false
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  # See https://artifacthub.io/packages/helm/argo/argo-cd for latest version(s)
  version = var.argo_helm_chart_version
  values  = [file("${path.module}/templates/values.yaml")]
  timeout = var.helm_timeout

  depends_on = [
    kubernetes_namespace.this
  ]

}

resource "helm_release" "argocd-apps" {
  count     = var.argocd_apps_enabled ? 1 : 0
  chart     = "argocd-apps"
  name      = "argocd-apps"
  namespace = var.namespace
  timeout   = var.helm_timeout

  repository = "https://argoproj.github.io/argo-helm"
  version    = var.argocd_apps_helm_chart_version
  values     = [var.argocd_apps_helm_values]

  depends_on = [helm_release.argocd]
}
