terraform {
  required_version = "~>1.11"
  # if using remote state s3
  # backend "s3" {
  #   bucket = ""
  #   key    = ""
  #   region = ""
  # }
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.22.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.0"
    }
    tls = {
      source = "hashicorp/tls"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.8.0"
    }
  }
}
