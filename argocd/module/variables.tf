variable "name" {
  type        = string
  description = "The generic name of ArgoCD deployment"
}

variable "namespace" {
  type        = string
  description = "ArgoCD namespace"
  default     = "argocd"
}

variable "helm_timeout" {
  description = "Timeout, in seconds, for helm deployment."
  default     = 600
}

variable "argo_helm_chart_version" {
  default     = "7.4.7"
  description = "Helm Chart version for the ArgoCD Helm Chart."
  validation {
    condition     = can(regex("^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$", var.argo_helm_chart_version))
    error_message = "Invalid helmchart semantic version"
  }
}

variable "argocd_apps_helm_chart_version" {
  default     = "2.0.0"
  description = "Helm Chart version for the ArgoCD Apps Helm Chart"
  type        = string

  validation {
    condition     = can(regex("^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$", var.argocd_apps_helm_chart_version))
    error_message = "Invalid helmchart semantic version"
  }

}

variable "argocd_cm_data" {
  description = "Additional configuration for ArgoCD configmap data. Please see https://github.com/argoproj/argo-cd/blob/master/docs/operator-manual/argocd-cm.yaml for details."
  type        = string
  default     = ""
}

variable "repository_secrets" {
  description = "Secrets to allow ArgoCD to access the repo"
  type = list(object({
    name        = string
    labels      = map(string)
    data        = optional(map(string))
    binary_data = optional(map(string))
    type        = optional(string)
  }))
  default = null
}

# ArgoCD Application Config
variable "argocd_apps_helm_values" {
  description = "If argocd_apps_enabled is true, provide your own values.yaml containing applications, projects or applicationset configs. Please see https://github.com/argoproj/argo-helm/blob/main/charts/argocd-apps/values.yaml for examples. A file's contents can then be passed to this variable by using example: `file(./templates/values.yml)`"
  type        = string
  default     = ""
}

variable "argocd_apps_enabled" {
  description = "Enable the variable allows you to configure and deploy applications, projects, applicationset,etc.. using [helm chart](https://github.com/argoproj/argo-helm/tree/main/charts/argocd-apps)"
  type        = bool
  default     = false
}
