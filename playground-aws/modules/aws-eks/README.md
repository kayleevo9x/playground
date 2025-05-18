# AWS EKS Comprehensive Terraform Module

This module provisions an Amazon Elastic Kubernetes Service (EKS) cluster along with the necessary supporting infrastructure. It is designed to be reusable and configurable for various Kubernetes workloads.

## Features

- Creates an EKS cluster with configurable node groups.
- Provisions a Virtual Private Cloud (VPC) with public and private subnets.
- Configures IAM roles and policies for the EKS cluster and worker nodes.
- Supports Kubernetes add-ons such as:
  - AWS Load Balancer Controller
  - ExternalDNS
  - CoreDNS
- Support ACM and route53 creation
- Enables tagging for all resources for better organization and cost tracking.


## Usage

```
module "eks" {
  source            = "./modules/aws-eks"
  cluster_name      = "demo-eks-cluster"
  create_acm        = true
  tags = {
    Environment = "dev"
    Project     = "example"
  }
}