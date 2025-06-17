resource "kubernetes_persistent_volume_claim" "nginx_config" {
  metadata {
    name      = "nginx-config-pvc"
    namespace = kubernetes_namespace.morpheus.metadata[0].name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Mi"
      }
    }
  }
  wait_until_bound = false
}
