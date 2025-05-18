# HelloWorld Kubernetes Deployment Module

This module provides a simple deployment for the "Hello Kubernetes" application on an existing Amazon Elastic Kubernetes Service (EKS) cluster. It is designed to demonstrate basic Kubernetes resource creation and integration with AWS services.

## Features

- Deploys the [paulbouwer/hello-kubernetes](https://hub.docker.com/r/paulbouwer/hello-kubernetes) containerized application.
- Creates Kubernetes resources:
  - **Namespace**
  - **Deployment**
  - **Service** (ClusterIP or NodePort)
  - **Ingress** (optional, with support for ALB or NGINX ingress controllers).
- Supports custom domain names and annotations for ingress.

## Usage

```
module "helloworld" {
  source              = "./modules/helloworld"
  enable_ingress      = true
  ingress_hostname    = "demo-app.devops.cloud"
  ingress_annotations = {
    "alb.ingress.kubernetes.io/certificate-arn"  = "arn:aws:acm:us-east-1:XXXXXXXXX:certificate/<cert-id>"
    "alb.ingress.kubernetes.io/security-groups"  = "sg-XXXXXXXXXX"
    "alb.ingress.kubernetes.io/subnets"          = "subnet-XXXXXXXXX, subnet-XXXXXXXXX, subnet-XXXXXXXXXX"
    "alb.ingress.kubernetes.io/ssl-redirect"     = "443"
    "alb.ingress.kubernetes.io/listen-ports"     = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
    "external-dns.alpha.kubernetes.io/hostname"  = var.ingress_hostname
    "alb.ingress.kubernetes.io/scheme"           = "internal"
  }
}