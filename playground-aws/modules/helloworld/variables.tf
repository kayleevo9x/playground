########
# App
########
variable "app_name" {
  description = "The name of the application instance."
  type        = string
  default     = "demo-helloworld"
}

variable "namespace" {
  description = "The namespace to deploy the application instance into."
  type        = string
  default     = "helloworld"
}

variable "replicas" {
  description = "The number of pods for this instance of the application instance."
  type        = number
  default     = 1
}


variable "service_port" {
  description = "The port you want the K8s service to listen on."
  type        = number
  default     = 8080
}

variable "image" {
  description = "Application instance image."
  type        = string
  default     = "paulbouwer/hello-kubernetes"
}

variable "image_tag" {
  description = "application instance image tag."
  type        = string
  default     = "1.10.1"
}

variable "container_port" {
  description = "The port the application container listens on."
  type        = number
  default     = 8080
}

##################
# Miscellanious
##################
variable "tags" {
  description = "User defined tags. Applied to all tag-able resources."
  type        = map(string)
  default     = {}
}

############
# Ingress
############

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
    validation {
    condition     = var.enable_ingress ? length(var.ingress_hostname) > 0 : true
    error_message = "ingress_hostname must be set if enable_ingress is true."
  }
}

variable "ingress_annotations" {
  type        = map(string)
  description = "Ingress annotations"
  default     = {}
}