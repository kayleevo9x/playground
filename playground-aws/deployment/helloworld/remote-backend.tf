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
      version = ">= 2.0.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.97.0"
    }
  }
}
