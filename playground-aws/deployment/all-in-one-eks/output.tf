output "cluster_name" {
  value = module.eks.cluster_name
}

output "public_subnet_ids" {
  value = module.eks.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.eks.private_subnet_ids
}

output "aws_cli" {
  value = module.eks.aws_cli
}

output "acm_certificate_arn" {
  value = try(module.eks.acm_certificate_arn, "")
}

output "domain_name" {
  value = try(module.eks.domain_name, "")
}