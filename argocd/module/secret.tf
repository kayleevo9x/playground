resource "kubernetes_secret" "example" {
  metadata {
    labels = {
      "argocd.argoproj.io/secret-type" = "repo-creds"
    }
    name      = "private-repo"
    namespace = kubernetes_namespace.this.metadata[0].name
  }
  data = {
    "type"          = "git"
    "url"           = var.org_repo_url
    "sshPrivateKey" = var.ssh_private_key
  }
  depends_on = [
    kubernetes_namespace.this
  ]
}
