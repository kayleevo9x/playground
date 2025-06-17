

resource "kubernetes_service_v1" "morpheus_vuln_analysis" {
  metadata {
    name      = "morpheus-vuln-analysis"
    namespace = "morpheus"
  }

  spec {
    selector = {
      app = "morpheus-vuln-analysis"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 80
    }

  }

  depends_on = [kubernetes_namespace.morpheus]
}


resource "kubernetes_ingress_v1" "this" {
  metadata {
    name      = "morpheus"
    namespace = kubernetes_namespace.morpheus.metadata[0].name
    annotations = {
      "alb.ingress.kubernetes.io/target-type"      = "ip"
      "alb.ingress.kubernetes.io/backend-protocol" = "HTTP"
      "alb.ingress.kubernetes.io/success-codes"    = "200,201,301,302"
      "alb.ingress.kubernetes.io/listen-ports"     = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
      "alb.ingress.kubernetes.io/scheme"           = "internal"
      "external-dns.alpha.kubernetes.io/hostname"  = "morpheus.${var.domain_name}"
      "alb.ingress.kubernetes.io/subnets"          = join(",", var.subnet_ids)
      "alb.ingress.kubernetes.io/ssl-redirect"     = "443"
      "alb.ingress.kubernetes.io/security-groups" = join(",", var.alb_security_group_ids)
      "alb.ingress.kubernetes.io/certificate-arn" = data.aws_acm_certificate.acm.arn
    }
  }

  spec {
    ingress_class_name = "alb"
    rule {
      host = "morpheus.${var.domain_name}"
      http {
        path {
          backend {
            service {
              name = kubernetes_service_v1.morpheus_vuln_analysis.metadata[0].name
              port {
                name = "http"
              }
            }
          }
          path      = "/*"
          path_type = "ImplementationSpecific"
        }
      }
    }
  }
}
