locals {
  default_tags = {
    Terraform   = "True"
    Namespace   = "Infrastructure"
    Environment = "Development"
  }
}

module "eks" {
  source = "../../modules/aws-eks"
  tags   = local.default_tags
}

module "eks_config" {
  source                = "../../modules/aws-eks-config"
  cluster_name          = module.eks.cluster_name
  eks_oidc_provider_arn = module.eks.cluster_oidc_provider_arn
  tags                  = local.default_tags
}
