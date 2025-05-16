resource "aws_security_group" "public-alb" {
  name        = "public-alb-sg"
  description = "Generic rule for public alb"
  vpc_id      = var.vpc_id
  # If using remote state, uncomment the line below
  # vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = merge({ Name = "public-alb" }, local.default_tags)

}

resource "aws_vpc_security_group_ingress_rule" "public_alb_http" {
  security_group_id = aws_security_group.public-alb.id
  description = "Allow HTTP traffic from the internet"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
  tags = merge({ Name = "public-alb" }, local.default_tags)
}

resource "aws_vpc_security_group_ingress_rule" "public_alb_https" {
  security_group_id = aws_security_group.public-alb.id
  description = "Allow HTTPS traffic from the internet"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
  tags = merge({ Name = "public-alb" }, local.default_tags)
}


resource "aws_vpc_security_group_egress_rule" "public_alb_egress" {
  security_group_id = aws_security_group.public-alb.id
  description = "Allow all outbound traffic"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_security_group" "private-alb" {
  name        = "private-alb-sg"
  description = "Generic rule for private alb"
  vpc_id      = var.vpc_id
  # If using remote state, uncomment the line below
  # vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = merge({ Name = "private-alb" }, local.default_tags)
}

resource "aws_vpc_security_group_ingress_rule" "private_alb_http" {
  for_each = toset(var.internal_cidrs)
  security_group_id = aws_security_group.private-alb.id
  description = "Allow HTTP traffic from the private subnets"
  cidr_ipv4   = each.value
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
  tags = merge({ Name = "private-alb" }, local.default_tags)
}

resource "aws_vpc_security_group_ingress_rule" "private_alb_https" {
  for_each = toset(var.internal_cidrs)
  security_group_id = aws_security_group.private-alb.id
  description = "Allow HTTPS traffic from the private subnets"
  cidr_ipv4   = each.value
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
  tags = merge({ Name = "private-alb" }, local.default_tags)
}

resource "aws_vpc_security_group_egress_rule" "private_alb_egress" {
  security_group_id = aws_security_group.private-alb.id
  description = "Allow all outbound traffic"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}