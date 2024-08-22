provider "helm" {
  kubernetes {
    config_path = "../local-kind-cluster/local-kind"
  }
}

provider "kubernetes" {
  config_path = "../local-kind-cluster/local-kind"
}

terraform {
  required_version = "1.8.1"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "= 2.31.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "= 2.14.0"
    }
  }
}
