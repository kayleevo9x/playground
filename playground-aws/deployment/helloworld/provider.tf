data "aws_caller_identity" "current" {
}

locals {
  default_tags = {
    Terraform   = "True"
    ClusterName = var.cluster_name
    Namespace   = "Infrastructure"
    Environment = "Development"
  }
}

provider "aws" {
  profile = "personal"
}

# If using remote state, 
# Define the eks remote state and uncomment the line below
# provider "kubernetes" {
#   cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.eks_ca_data)
#   host                   = data.terraform_remote_state.eks.outputs.eks_cluster_endpoint
#   exec {
#     api_version = "client.authentication.k8s.io/v1"
#     args        = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.eks.outputs.eks_cluster_name]
#     command     = "aws"
#   }
# }


provider "kubernetes" {
  config_path    = var.kubeconfig_path
  config_context = var.cluster_name
}