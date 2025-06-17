variable "eks_oidc_provider_arn" {
  type        = string
  description = "The ARN of the OIDC provider for the EKS cluster"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "domain_name" {
  description = "The domain name to use for the external DNS"
  type        = string
  default     = ""
}

variable "enable_nvidia_device_plugin" {
  description = "Enable the NVIDIA device plugin for EKS"
  type        = bool
  default     = false

}
variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
