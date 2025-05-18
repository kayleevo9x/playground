cluster_name    = "demo-eks-cluster"
kubeconfig_path = "~/.kube/config"

# Ingress related info
enable_ingress     = true
ingress_class_name = "alb"                   # or "nginx"
ingress_hostname   = "" # e.g. "demo-app.example.cloud"

# Ingress annotations 
# Below is an example for an internal ALB ingress
ingress_annotations = {
  #"alb.ingress.kubernetes.io/certificate-arn" = "arn:aws:acm:us-east-1:XXXXXXXXX:certificate/<cert-id>"
  #"alb.ingress.kubernetes.io/security-groups" = "sg-XXXXXXXXXX"
  # "alb.ingress.kubernetes.io/subnets" = "subnet-XXXXXXXXX, subnet-XXXXXXXXX, subnet-XXXXXXXXXX"
  #"alb.ingress.kubernetes.io/ssl-redirect"     = "443"
  #"alb.ingress.kubernetes.io/listen-ports"     = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
  #"external-dns.alpha.kubernetes.io/hostname"  = var.ingress_hostname
  #"alb.ingress.kubernetes.io/scheme"  = "internal"
  "alb.ingress.kubernetes.io/scheme"  = "internet-facing"
}

service_type = "NodePort" # or "ClusterIP" if using externalDNS to create DNS records and access the service through https