resource "kubernetes_namespace" "this" {
  metadata {
    name = var.name
  }
}

locals {
  argo_app_values_vars = {
    repo_url = var.repo_url
    self_heal = var.self_heal
  }
  argo_app_helm_values = templatefile("${path.module}/templates/applications.yaml", local.argo_app_values_vars)
}

resource "helm_release" "argocd" {
  name             = var.name
  namespace        = kubernetes_namespace.this.metadata[0].name
  create_namespace = false
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  # See https://artifacthub.io/packages/helm/argo/argo-cd for latest version(s)
  version = "5.16.9"
  values = [file("${path.module}/templates/values-override.yaml")]
  timeout = var.helm_timeout

  depends_on = [
    kubernetes_namespace.this
  ]

}

resource "helm_release" "argocd-apps" {
  depends_on       = [helm_release.argocd]
  chart            = "argocd-apps"
  name             = "argocd-apps"
  namespace        = "argocd"
  create_namespace = false

  repository = "https://argoproj.github.io/argo-helm"
  version    = "0.0.6"
  values = [
    local.argo_app_helm_values
  ]
}
