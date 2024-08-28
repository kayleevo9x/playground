provider "helm" {
  kubernetes {
    config_path = "../local-kind-cluster/local-kind"
  }
}

provider "kubernetes" {
  config_path = "../local-kind-cluster/local-kind"
}

provider "github" {
  # Set your environment variable GITHUB_TOKEN with personal access token in order to use this provider
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
    github = {
      source  = "integrations/github"
      version = "6.2.3"
    }
  }
}
