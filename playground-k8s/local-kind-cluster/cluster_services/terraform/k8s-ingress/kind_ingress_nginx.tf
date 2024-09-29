resource "kubernetes_namespace_v1" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"

    labels = {
      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"
    }
  }
}

resource "kubernetes_service_account" "ingress_nginx" {
  metadata {
    name      = "ingress-nginx"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata[0].name

    labels = {
      "app.kubernetes.io/component" = "controller"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = var.nginx_version
    }
  }

  automount_service_account_token = true
}

resource "kubernetes_service_account" "ingress_nginx_admission" {
  metadata {
    name      = "ingress-nginx-admission"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata[0].name

    labels = {
      "app.kubernetes.io/component" = "admission-webhook"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = var.nginx_version
    }
  }
}

resource "kubernetes_role" "ingress_nginx" {
  metadata {
    name      = "ingress-nginx"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata[0].name

    labels = {
      "app.kubernetes.io/component" = "controller"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = var.nginx_version
    }
  }

  rule {
    verbs      = ["get"]
    api_groups = [""]
    resources  = ["namespaces"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["configmaps", "pods", "secrets", "endpoints"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["services"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses"]
  }

  rule {
    verbs      = ["update"]
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses/status"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["networking.k8s.io"]
    resources  = ["ingressclasses"]
  }

  rule {
    verbs          = ["get", "update"]
    api_groups     = ["coordination.k8s.io"]
    resources      = ["leases"]
    resource_names = ["ingress-nginx-leader"]
  }

  rule {
    verbs      = ["create"]
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
  }

  rule {
    verbs      = ["create", "patch"]
    api_groups = [""]
    resources  = ["events"]
  }

  rule {
    verbs      = ["list", "watch", "get"]
    api_groups = ["discovery.k8s.io"]
    resources  = ["endpointslices"]
  }
}

resource "kubernetes_role" "ingress_nginx_admission" {
  metadata {
    name      = "ingress-nginx-admission"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata[0].name

    labels = {
      "app.kubernetes.io/component" = "admission-webhook"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = var.nginx_version
    }
  }

  rule {
    verbs      = ["get", "create"]
    api_groups = [""]
    resources  = ["secrets"]
  }
}

resource "kubernetes_cluster_role" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"

    labels = {
      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = var.nginx_version
    }
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = [""]
    resources  = ["configmaps", "endpoints", "nodes", "pods", "secrets", "namespaces"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
  }

  rule {
    verbs      = ["get"]
    api_groups = [""]
    resources  = ["nodes"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["services"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses"]
  }

  rule {
    verbs      = ["create", "patch"]
    api_groups = [""]
    resources  = ["events"]
  }

  rule {
    verbs      = ["update"]
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses/status"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["networking.k8s.io"]
    resources  = ["ingressclasses"]
  }

  rule {
    verbs      = ["list", "watch", "get"]
    api_groups = ["discovery.k8s.io"]
    resources  = ["endpointslices"]
  }
}

resource "kubernetes_cluster_role" "ingress_nginx_admission" {
  metadata {
    name = "ingress-nginx-admission"

    labels = {
      "app.kubernetes.io/component" = "admission-webhook"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = var.nginx_version
    }
  }

  rule {
    verbs      = ["get", "update"]
    api_groups = ["admissionregistration.k8s.io"]
    resources  = ["validatingwebhookconfigurations"]
  }
}

resource "kubernetes_role_binding" "ingress_nginx" {
  metadata {
    name      = "ingress-nginx"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata[0].name

    labels = {
      "app.kubernetes.io/component" = "controller"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = var.nginx_version
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "ingress-nginx"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "ingress-nginx"
  }
}

resource "kubernetes_role_binding" "ingress_nginx_admission" {
  metadata {
    name      = "ingress-nginx-admission"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata[0].name

    labels = {
      "app.kubernetes.io/component" = "admission-webhook"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = var.nginx_version
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "ingress-nginx-admission"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "ingress-nginx-admission"
  }
}

resource "kubernetes_cluster_role_binding" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"

    labels = {
      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = var.nginx_version
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "ingress-nginx"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "ingress-nginx"
  }
}

resource "kubernetes_cluster_role_binding" "ingress_nginx_admission" {
  metadata {
    name = "ingress-nginx-admission"

    labels = {
      "app.kubernetes.io/component" = "admission-webhook"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = var.nginx_version
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "ingress-nginx-admission"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "ingress-nginx-admission"
  }
}

resource "kubernetes_config_map" "ingress_nginx_controller" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata[0].name

    labels = {
      "app.kubernetes.io/component" = "controller"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = var.nginx_version
    }
  }

  data = {
    allow-snippet-annotations = "false"
  }
}

resource "kubernetes_service" "ingress_nginx_controller" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata[0].name

    labels = {
      "app.kubernetes.io/component" = "controller"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = var.nginx_version
    }
  }

  spec {
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 80
      target_port = "http"
    }

    port {
      name        = "https"
      protocol    = "TCP"
      port        = 443
      target_port = "https"
    }

    selector = {
      "app.kubernetes.io/component" = "controller"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"
    }

    type        = "NodePort"
    ip_families = ["IPv4"]
  }
}

resource "kubernetes_service" "ingress_nginx_controller_admission" {
  metadata {
    name      = "ingress-nginx-controller-admission"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata[0].name

    labels = {
      "app.kubernetes.io/component" = "controller"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = var.nginx_version
    }
  }

  spec {
    port {
      name        = "https-webhook"
      port        = 443
      target_port = "webhook"
    }

    selector = {
      "app.kubernetes.io/component" = "controller"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"
    }

    type = "ClusterIP"
  }
}


resource "kubernetes_job" "ingress_nginx_admission_create" {
  metadata {
    name      = "ingress-nginx-admission-create"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata[0].name

    labels = {
      "app.kubernetes.io/component" = "admission-webhook"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = var.nginx_version
    }
  }

  spec {
    template {
      metadata {
        name = "ingress-nginx-admission-create"

        labels = {
          "app.kubernetes.io/component" = "admission-webhook"

          "app.kubernetes.io/instance" = "ingress-nginx"

          "app.kubernetes.io/name" = "ingress-nginx"

          "app.kubernetes.io/part-of" = "ingress-nginx"

          "app.kubernetes.io/version" = var.nginx_version
        }
      }

      spec {
        container {
          name  = "create"
          image = "registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.4.0@sha256:44d1d0e9f19c63f58b380c5fddaca7cf22c7cee564adeff365225a5df5ef3334"
          args  = ["create", "--host=ingress-nginx-controller-admission,ingress-nginx-controller-admission.$(POD_NAMESPACE).svc", "--namespace=$(POD_NAMESPACE)", "--secret-name=ingress-nginx-admission"]

          env {
            name = "POD_NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 65532
            run_as_non_root           = true
            read_only_root_filesystem = true
          }
        }

        restart_policy = "OnFailure"

        node_selector = {
          "kubernetes.io/os" = "linux"
        }

        service_account_name = "ingress-nginx-admission"
      }
    }
  }
}

resource "kubernetes_job" "ingress_nginx_admission_patch" {
  metadata {
    name      = "ingress-nginx-admission-patch"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata[0].name

    labels = {
      "app.kubernetes.io/component" = "admission-webhook"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = var.nginx_version
    }
  }

  spec {
    template {
      metadata {
        name = "ingress-nginx-admission-patch"

        labels = {
          "app.kubernetes.io/component" = "admission-webhook"

          "app.kubernetes.io/instance" = "ingress-nginx"

          "app.kubernetes.io/name" = "ingress-nginx"

          "app.kubernetes.io/part-of" = "ingress-nginx"

          "app.kubernetes.io/version" = var.nginx_version
        }
      }

      spec {
        container {
          name  = "patch"
          image = "registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.4.0@sha256:44d1d0e9f19c63f58b380c5fddaca7cf22c7cee564adeff365225a5df5ef3334"
          args  = ["patch", "--webhook-name=ingress-nginx-admission", "--namespace=$(POD_NAMESPACE)", "--patch-mutating=false", "--secret-name=ingress-nginx-admission", "--patch-failure-policy=Fail"]

          env {
            name = "POD_NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 65532
            run_as_non_root           = true
            read_only_root_filesystem = true
          }
        }

        restart_policy = "OnFailure"

        node_selector = {
          "kubernetes.io/os" = "linux"
        }

        service_account_name = "ingress-nginx-admission"
      }
    }
  }
}

resource "kubernetes_ingress_class" "nginx" {
  metadata {
    name = "nginx"

    labels = {
      "app.kubernetes.io/component" = "controller"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = var.nginx_version
    }
  }

  spec {
    controller = "k8s.io/ingress-nginx"
  }
}

resource "kubernetes_validating_webhook_configuration" "ingress_nginx_admission" {
  metadata {
    name = "ingress-nginx-admission"

    labels = {
      "app.kubernetes.io/component" = "admission-webhook"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = var.nginx_version
    }
  }

  webhook {
    name = "validate.nginx.ingress.kubernetes.io"

    client_config {
      service {
        namespace = kubernetes_namespace_v1.ingress_nginx.metadata[0].name
        name      = "ingress-nginx-controller-admission"
        path      = "/networking/v1/ingresses"
      }
    }

    rule {
      api_versions = ["v1beta1"]
      api_groups   = ["networking.k8s.io"]
      resources    = ["ingresses"]
      operations   = ["CREATE", "UPDATE"]
    }

    failure_policy            = "Fail"
    match_policy              = "Equivalent"
    side_effects              = "None"
    admission_review_versions = ["v1"]
  }
}

resource "kubernetes_deployment" "ingress_nginx_controller" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata[0].name

    labels = {
      "app.kubernetes.io/component" = "controller"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = var.nginx_version
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "controller"

        "app.kubernetes.io/instance" = "ingress-nginx"

        "app.kubernetes.io/name" = "ingress-nginx"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "controller"

          "app.kubernetes.io/instance" = "ingress-nginx"

          "app.kubernetes.io/name" = "ingress-nginx"

          "app.kubernetes.io/part-of" = "ingress-nginx"

          "app.kubernetes.io/version" = var.nginx_version
        }
      }

      spec {
        volume {
          name = "webhook-cert"

          secret {
            secret_name = "ingress-nginx-admission"
          }
        }

        container {
          name  = "controller"
          image = "registry.k8s.io/ingress-nginx/controller:v${var.nginx_version}@sha256:42b3f0e5d0846876b1791cd3afeb5f1cbbe4259d6f35651dcc1b5c980925379c"
          args  = ["/nginx-ingress-controller", "--election-id=ingress-nginx-leader", "--controller-class=k8s.io/ingress-nginx", "--ingress-class=nginx", "--configmap=$(POD_NAMESPACE)/ingress-nginx-controller", "--validating-webhook=:8443", "--validating-webhook-certificate=/usr/local/certificates/cert", "--validating-webhook-key=/usr/local/certificates/key", "--watch-ingress-without-class=true", "--enable-metrics=false", "--publish-status-address=localhost"]

          port {
            name           = "http"
            host_port      = 80
            container_port = 80
            protocol       = "TCP"
          }

          port {
            name           = "https"
            host_port      = 443
            container_port = 443
            protocol       = "TCP"
          }

          port {
            name           = "webhook"
            container_port = 8443
            protocol       = "TCP"
          }

          env {
            name = "POD_NAME"

            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          env {
            name = "POD_NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          env {
            name  = "LD_PRELOAD"
            value = "/usr/local/lib/libmimalloc.so"
          }

          resources {
            requests = {
              cpu = "100m"

              memory = "90Mi"
            }
          }

          volume_mount {
            name       = "webhook-cert"
            read_only  = true
            mount_path = "/usr/local/certificates/"
          }

          liveness_probe {
            http_get {
              path   = "/healthz"
              port   = "10254"
              scheme = "HTTP"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 5
          }

          readiness_probe {
            http_get {
              path   = "/healthz"
              port   = "10254"
              scheme = "HTTP"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 3
          }

          lifecycle {
            pre_stop {
              exec {
                command = ["/wait-shutdown"]
              }
            }
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              add  = ["NET_BIND_SERVICE"]
              drop = ["ALL"]
            }

            run_as_user     = 101
            run_as_non_root = true
          }
        }

        dns_policy = "ClusterFirst"

        node_selector = {
          ingress-ready      = "true"
          "kubernetes.io/os" = "linux"
        }

        service_account_name = "ingress-nginx"

        toleration {
          key      = "node-role.kubernetes.io/master"
          operator = "Equal"
          effect   = "NoSchedule"
        }

        toleration {
          key      = "node-role.kubernetes.io/control-plane"
          operator = "Equal"
          effect   = "NoSchedule"
        }
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_unavailable = "1"
      }
    }

    revision_history_limit = 10
  }
}
