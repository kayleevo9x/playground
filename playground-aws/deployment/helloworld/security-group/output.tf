
output "public_alb_sg_id" {
  value       = aws_security_group.public-alb.id
  description = "Public ALB Security Group ID"

}

output "private_alb_sg_id" {
  value       = aws_security_group.private-alb.id
  description = "Private ALB Security Group ID"
}

output "eks_node_sg_id" {
  value       = aws_security_group.eks_node.id
  description = "Generic EKS node security group to allow traffic from the public and private ALB security groups. Attach this to the EKS node group."
}
