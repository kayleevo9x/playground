# AWS EKS Configuration Module

This module provides configurations for managing Kubernetes add-ons and integrations for an Amazon Elastic Kubernetes Service (EKS) cluster. It is designed to simplify the deployment and management of essential Kubernetes components.

## Features

- **AWS Load Balancer Controller**: For managing Application Load Balancers (ALBs) and Network Load Balancers (NLBs).
- **ExternalDNS**: For dynamically managing DNS records in Route 53.


## Usage

```
module "eks_config" {
  source                = "./modules/aws-eks-config"
  cluster_name          = module.eks.cluster_name
  eks_oidc_provider_arn = module.eks.cluster_oidc_provider_arn
  domain_name           = "devops.cloud"
}