locals {
  repository_secrets = var.repository_secrets != null ? { for secret in var.repository_secrets : secret.name => secret } : {}
}

resource "kubernetes_secret" "repo_secret" {
  for_each = local.repository_secrets
  metadata {
    name      = each.value.name
    namespace = var.namespace
    labels    = each.value.labels
  }

  data        = each.value.data != null ? each.value.data : {}
  binary_data = each.value.binary_data != null ? each.value.binary_data : {}
  type        = each.value.type != null ? each.value.type : "Opaque"
}
