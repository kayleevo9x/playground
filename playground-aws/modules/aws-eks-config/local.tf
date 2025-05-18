locals {
  default_tags = merge(var.tags, {
    Terraform = "True"
  })

}