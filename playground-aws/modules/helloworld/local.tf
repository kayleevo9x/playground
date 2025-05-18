locals {
  app_name  = "helloworld"
  namespace = "helloworld"
  default_tags = merge(var.tags, {
    Terraform = "True"
  })

  default_alb_ingress_annotations = {
    "alb.ingress.kubernetes.io/target-type"      = "ip"
    "alb.ingress.kubernetes.io/backend-protocol" = "HTTP"
    "alb.ingress.kubernetes.io/success-codes"    = "200,201,301,302"
    "alb.ingress.kubernetes.io/listen-ports"     = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
    "alb.ingress.kubernetes.io/tags"             = join(",", [for k, v in local.default_tags : "${k}=${v}"])
  }

  ingress_annotations = var.ingress_class_name == "alb" ? merge(local.default_alb_ingress_annotations, var.ingress_annotations) : var.ingress_annotations

}
