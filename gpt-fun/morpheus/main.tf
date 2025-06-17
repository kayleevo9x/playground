provider "aws" {
  alias  = "bootstrap"
  region = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.bootstrap
}
locals {
  default_tags = {
    Terraform   = "True"
    Namespace   = "Infrastructure"
    Environment = "Development"
  }

  nims_namespace = "nims"
}

provider "aws" {
}

provider "kubernetes" {
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.eks_ca_data)
  host                   = data.terraform_remote_state.eks.outputs.eks_cluster_endpoint
  exec {
    api_version = "client.authentication.k8s.io/v1"
    args        = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.eks.outputs.eks_cluster_name]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.eks_ca_data)
    host                   = data.terraform_remote_state.eks.outputs.eks_cluster_endpoint
    exec {
      api_version = "client.authentication.k8s.io/v1"
      args        = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.eks.outputs.eks_cluster_name]
      command     = "aws"
    }
  }
}