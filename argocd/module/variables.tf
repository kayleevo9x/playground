variable "name" {
  type        = string
  description = "The generic name of ArgoCD deployment"
}

variable "helm_timeout" {
  description = "Timeout, in seconds, for helm deployment."
  default     = 600
}

variable "ssh_private_key" {
  description = "ssh private key to connect to private repo"
  default = ""
}

variable "org_repo_url" {
  description = "Org repo to ssh to"
  default = "git@github.com:MarketTrack"
}

# ArgoCD Application Config
variable "self_heal" {
  description = "If true, manual changes made to cluster will be discarded by the autosync feature in ArgoCD"
  default = true

}
variable "repo_url" {
  description = "Full repo path to connect to ArgoCD"
  default = "git@github.com:MarketTrack/nmr-xavier-sandbox.git"

}