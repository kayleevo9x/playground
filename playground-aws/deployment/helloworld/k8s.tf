module "helloworld" {
  source = "../../modules/helloworld"

  enable_ingress      = var.enable_ingress
  ingress_class_name  = var.ingress_class_name
  ingress_hostname    = var.ingress_hostname
  ingress_annotations = var.ingress_annotations
}