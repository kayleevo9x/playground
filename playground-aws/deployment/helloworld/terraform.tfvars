cluster_name    = "<your-cluster-name>"
kubeconfig_path = "~/.kube/config"

# Ingress related info
enable_ingress     = true
ingress_class_name = "alb" # or "nginx"
ingress_hostname   = "<your-hostname>" # e.g. "demo-app.example.cloud"

# Ingress annotations 
# Below is an example for an internal ALB ingress
ingress_annotations = {
  "alb.ingress.kubernetes.io/certificate-arn" = "arn:aws:acm:<region>:XXXXXXXX:certificate/<certificate-id>"
  "alb.ingress.kubernetes.io/security-groups" = "sg-XXXXXXXXXX"
  "alb.ingress.kubernetes.io/subnets"         = "subnet-XXXXXXXXXXXa, subnet-XXXXXXXXXXXb, subnet-XXXXXXXXXXXc"
  "alb.ingress.kubernetes.io/scheme"          = "internal"
}
