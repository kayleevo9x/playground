data "aws_acm_certificate" "acm" {
  domain   = "*.${var.domain_name}"
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "acm" {
  name         = "${var.domain_name}."
  private_zone = false
}
