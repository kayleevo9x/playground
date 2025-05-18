locals {
  default_tags = merge(var.tags, {
    Terraform = "True"
  })
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
  vpc_cidr = "10.0.0.0/16"

  aws_cli = templatefile("${path.module}/templates/aws-cli.yaml", {
    eks_cluster_name = var.cluster_name
    aws_region       = var.region
  })

}