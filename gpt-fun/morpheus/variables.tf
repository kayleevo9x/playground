variable "github_token" {
  description = "GitHub token for accessing private repositories"
  type        = string
  sensitive   = true
  default     = "reacted"
}

variable "nvd_api_key" {
  description = "NVD API Key for accessing the National Vulnerability Database"
  type        = string
  sensitive   = true
  default     = "reacted"
}

variable "nvidia_api_key" {
  description = "NVIDIA API Key for accessing NVIDIA services"
  type        = string
  sensitive   = true
  default     = "reacted"
  
}

variable "serpapi_api_key" {
  description = "SerpAPI Key for accessing search engine results"
  type        = string
  sensitive   = true
  default     = "reacted"
  
}

variable "oidc_provider_arn" {
  description = "value of the OIDC provider ARN"
  type        = string
  default     = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.us-west-2.amazonaws.com/id/EXAMPLE"
}

variable "domain_name" {
  description = "The domain name to use for the external DNS"
  type        = string
  default     = ""
  
}

variable "subnet_ids" {
  description = "value of the subnet IDs"
  type        = list(string)
  default     = ["subnet-12345678", "subnet-87654321"]
}

variable "alb_security_group_ids" {
  default = ["sg-12345678", "sg-87654321"]
  description = "List of security group IDs for the ALB"
  type        = list(string)
}