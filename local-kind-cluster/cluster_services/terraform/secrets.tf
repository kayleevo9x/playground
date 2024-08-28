# A secret pre-generated to be used for postgresql deployment by argoCDs
locals {
  namespaces = ["urlshortener", "postgresql"]
}
resource "kubernetes_namespace_v1" "name" {
  count = length(local.namespaces)
  metadata {
    name = local.namespaces[count.index]
  }
}

resource "random_password" "postgres" {
  length           = 15
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "kubernetes_secret_v1" "this" {
  count = length(local.namespaces)
  metadata {
    name      = "postgresql"
    namespace = kubernetes_namespace_v1.name[count.index].metadata[0].name
  }

  data = {
    POSTGRES_PASSWORD = random_password.postgres.result
    POSTGRES_USER     = "ps_user"
    POSTGRES_DB       = "app"
  }
}
