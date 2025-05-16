variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
  default     = ""
  
}

variable "internal_cidrs" {
  description = "The CIDR blocks for the internal network"
  type        = list(string)
  default     = []
  
}