output "cluster_role_arn" {
  description = "EKS cluster IAM role ARN"
  value       = aws_iam_role.eks_cluster.arn
}

output "node_role_arn" {
  description = "Node group IAM role ARN"
  value       = aws_iam_role.node.arn
}

output "node_instance_profile" {
  description = "Node instance profile name"
  value       = aws_iam_instance_profile.node.name
}