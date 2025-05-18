terraform {
  required_version = "1.11.2"
  # if using remote state s3
  # backend "s3" {
  #   bucket = ""
  #   key    = ""
  #   region = ""
  # }
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.36.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.97.0"
    }
  }
}
