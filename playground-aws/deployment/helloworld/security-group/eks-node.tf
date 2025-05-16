resource "aws_security_group" "eks_node" {
  name        = "eks-node-sg"
  description = "Generic rule for eks nodes"
  vpc_id      = var.vpc_id

  tags = merge({ Name = "eks-node" }, local.default_tags)
}

resource "aws_vpc_security_group_ingress_rule" "eks_node_public_apps_ingress" {
  security_group_id        = aws_security_group.eks_node.id
  ip_protocol                 = "-1"
  referenced_security_group_id = aws_security_group.public-alb.id
}

resource "aws_vpc_security_group_ingress_rule" "eks_node_private_apps_ingress" {
  security_group_id        = aws_security_group.eks_node.id
  ip_protocol                 = "-1"
  referenced_security_group_id = aws_security_group.private-alb.id
}
