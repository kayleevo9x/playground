provider "helm" {
  kubernetes {
    config_path = "../../local-kind"
  }
}

provider "kubernetes" {
  config_path = "../../local-kind"
}

terraform {
  required_version = "= 1.8.1"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.9.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "> 2.0.0"
    }
  }
}
