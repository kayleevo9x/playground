variable "region" {
  default     = "us-east-1"
  type        = string
  description = "AWS region to deploy the resources"
}

variable "cluster_name" {
  default     = "demo-eks-cluster"
  description = "Name of the EKS cluster"
  type        = string
}

variable "eks_version" {
  description = "Version of the EKS Cluster (eg: 1.32)."
  type        = string
  default     = "1.32"
  validation {
    condition     = var.eks_version == null ? true : can(regex("\\d+\\.\\d+\\.?\\d+$", var.eks_version))
    error_message = "Invalid kubernetes sematic version."
  }
}

variable "create_acm" {
  description = "Enable to create ACM certificates and validates them using Route53 DNS. The certification validation may take more than 1 hour to complete"
  type        = bool
  default     = false 
}

variable "domain_name" {
  description = "A domain name for which the certificate should be issued"
  type        = string
  default     = ""
  validation {
    condition     = var.create_acm ? length(var.domain_name) > 0 : true
    error_message = "domain_name must be set if create_acm is true."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
