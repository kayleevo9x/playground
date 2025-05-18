variable "enable_ingress" {
  type        = bool
  default     = false
  description = "Whether to create an Ingress resource"
}

variable "ingress_class_name" {
  description = "The K8s IngressClass to use for the ingress."
  type        = string
  default     = "alb"
}

variable "ingress_hostname" {
  type        = string
  description = "Ingress hostname"
  default     = ""
}

variable "ingress_annotations" {
  type        = map(string)
  description = "Ingress annotations"
  default     = {}
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
  default     = ""

}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
  default     = ""

}

variable "kubeconfig_path" {
  description = "The path to the kubeconfig file"
  type        = string
  default     = ""

}
