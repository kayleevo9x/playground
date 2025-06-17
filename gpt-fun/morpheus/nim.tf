# NIMs configuration
resource "kubernetes_namespace_v1" "nims" {
  metadata {
    name = local.nims_namespace
    labels = {
      name = local.nims_namespace
    }
  }
}

resource "kubernetes_secret_v1" "nvidia_registry_secret" {
  metadata {
    name      = "nvidia-registry-secret"
    namespace = local.nims_namespace
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "nvcr.io" = {
          auth = base64encode("$oauthtoken:${data.aws_secretsmanager_secret_version.nims_secret.secret_string}")
        }
      }
    })
  }

  depends_on = [kubernetes_namespace_v1.nims, aws_secretsmanager_secret.nvidia_api_key]
}

data "aws_secretsmanager_secret_version" "nims_secret" {
  secret_id = aws_secretsmanager_secret.nvidia_api_key.id
}


resource "kubernetes_secret_v1" "nims_secret" {
  metadata {
    name      = "nvidia-api-key"
    namespace = local.nims_namespace
  }

  type = "Opaque"

  data = {
    NGC_API_KEY = data.aws_secretsmanager_secret_version.nims_secret.secret_string
  }

  depends_on = [kubernetes_namespace_v1.nims, aws_secretsmanager_secret.nvidia_api_key]
}

resource "kubernetes_deployment_v1" "nims" {
  metadata {
    name      = "nims-deployment"
    namespace = local.nims_namespace
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nims"
      }
    }

    template {
      metadata {
        labels = {
          app = "nims"
        }
      }

      spec {
        image_pull_secrets {
          name = "nvidia-registry-secret"
        }
        node_selector = {
          "gpu-shared" = "true"
        }
        toleration {
          key      = "nvidia.com/gpu-shared"
          operator = "Exists"
          effect   = "NoSchedule"
        }
        container {
          name  = "nims"
          image = "nvcr.io/nim/meta/llama3-8b-instruct:1.0.0"

          port {
            container_port = 8000
          }

          env {
            name = "NGC_API_KEY"
            value_from {
              secret_key_ref {
                name = "nvidia-api-key" // <-- synced by eks-secrets module from k8s_secrets.tf
                key  = "NGC_API_KEY"
              }
            }
          }

          volume_mount {
            name       = "nim-cache"
            mount_path = "/opt/nim/.cache"
          }

          volume_mount {
            name       = "dshm"
            mount_path = "/dev/shm"
          }

          resources {
            requests = {
              cpu    = "2"
              memory = "16Gi"
            }
            limits = {
              cpu                     = "4"
              memory                  = "32Gi"
              "nvidia.com/gpu.shared" = 1
            }
          }

          security_context {
            run_as_user = 1000
          }
        }

        volume {
          name = "nim-cache"
          empty_dir {}
        }

        volume {
          name = "dshm"
          empty_dir {
            medium     = "Memory"
            size_limit = "16Gi"
          }
        }
      }
    }
  }

  depends_on = [
    module.nvidia_api_key_secret,
    kubernetes_secret_v1.nvidia_registry_secret
  ]
}

resource "kubernetes_service_v1" "nims" {
  metadata {
    name      = "nims-service"
    namespace = local.nims_namespace
  }

  spec {
    selector = {
      app = "nims"
    }

    port {
      protocol    = "TCP"
      port        = 8000
      target_port = 8000
    }
  }

  depends_on = [
    kubernetes_deployment_v1.nims
  ]

}

resource "kubernetes_deployment_v1" "nim_embed" {
  metadata {
    name      = "nim-embed-deployment"
    namespace = local.nims_namespace
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nim-embed"
      }
    }

    template {
      metadata {
        labels = {
          app = "nim-embed"
        }
      }

      spec {
        image_pull_secrets {
          name = "nvidia-registry-secret"
        }
        node_selector = {
          "gpu" = "true"
        }
        toleration {
          key      = "nvidia.com/gpu"
          operator = "Exists"
          effect   = "NoSchedule"
        }
        container {
          name  = "nim-embed"
          image = "nvcr.io/nim/nvidia/nv-embedqa-e5-v5:1.0.1"
          port {
            container_port = 8000
          }

          env {
            name = "NGC_API_KEY"
            value_from {
              secret_key_ref {
                name = "nvidia-api-key" // <-- synced by eks-secrets module from k8s_secrets.tf
                key  = "NGC_API_KEY"
              }
            }
          }


          volume_mount {
            name       = "nim-embedding-cache"
            mount_path = "/opt/nim/.cache"
          }

          volume_mount {
            name       = "dshm"
            mount_path = "/dev/shm"
          }

          resources {
            requests = {
              cpu    = "2"
              memory = "16Gi"
            }
            limits = {
              cpu                     = "4"
              memory                  = "32Gi"
              "nvidia.com/gpu.shared" = 1
            }
          }
        }

        volume {
          name = "nim-embedding-cache"
          empty_dir {}
        }

        volume {
          name = "dshm"
          empty_dir {
            medium     = "Memory"
            size_limit = "16Gi"
          }
        }
      }
    }
  }

  depends_on = [
    module.nvidia_api_key_secret,
    kubernetes_secret_v1.nvidia_registry_secret
  ]
}

resource "kubernetes_service_v1" "nim_embed" {
  metadata {
    name      = "nim-embed-service"
    namespace = local.nims_namespace
  }

  spec {
    selector = {
      app = "nim-embed"
    }

    port {
      name        = "http"
      protocol    = "TCP"
      port        = 8000
      target_port = 8000
    }

    type = "ClusterIP"
  }

  depends_on = [
    kubernetes_deployment_v1.nim_embed
  ]
}
