resource "aws_route53_zone" "this" {
  count = var.create_acm ? 1 : 0
  name = "devops.cloud"
}

module "acm" {
  count       = var.create_acm ? 1 : 0
  source      = "terraform-aws-modules/acm/aws"
  version     = " ~> 5.0"
  domain_name = "devops.cloud"
  subject_alternative_names = [
    "*.devops.cloud"
  ]
  zone_id             = aws_route53_zone.this[0].zone_id
  validation_method   = "DNS"
  wait_for_validation = false
  tags                = local.default_tags
}