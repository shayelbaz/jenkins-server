output "cluster_name" {
  value       = aws_eks_cluster.myCluster.name
}

output "cluster_arn" {
  value       = aws_eks_cluster.myCluster.arn
}

output "cluster_certificate_authority_data" {
  value       = aws_eks_cluster.myCluster.certificate_authority[0].data
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.myCluster.endpoint
}

output "cluster_version" {
  value       = aws_eks_cluster.myCluster.version
}