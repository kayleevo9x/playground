resource "kubernetes_namespace_v1" "this" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_deployment_v1" "this" {
  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    labels    = { app = var.app_name }
  }

  spec {
    replicas = var.replicas
    selector {
      match_labels = { app = var.app_name }
    }

    template {
      metadata {
        labels = { app = var.app_name }
      }

      spec {
        container {
          name  = var.app_name
          image = "${var.image}:${var.image_tag}"

          port {
            name          = "http"
            container_port = var.container_port

          }
          liveness_probe {
            http_get {
              path = "/"
              port = "http"
            }
          }

          readiness_probe {
            http_get {
              path = "/"
              port = "http"
            }
          }
          
          env {
            name = "KUBERNETES_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "this" {
  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    labels    = { app = var.app_name }
  }

  spec {
    selector = { app = var.app_name }
    port {
      name        = "http"
      port        = var.service_port
      target_port = var.container_port
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "this" {
  count = var.enable_ingress ? 1 : 0
  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    annotations = local.ingress_annotations
  }

  spec {
    ingress_class_name = var.ingress_class_name
    rule {
      host = var.ingress_hostname
      http {
        path {
          backend {
            service {
              name = kubernetes_service_v1.this.metadata[0].name
              port {
                name = "http"
              }
            }
          }
          path      = "/"
          path_type = "Prefix"
        }
      }
    }
  }
}