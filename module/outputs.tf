# Outputs for the EKS module

output "cluster_id" {
  description = "EKS cluster ID"
  value       = var.is_eks_cluster_created ? aws_eks_cluster.eks_cluster[0].id : ""
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = var.is_eks_cluster_created ? aws_eks_cluster.eks_cluster[0].endpoint : ""
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster OIDC Issuer"
  value       = var.is_eks_cluster_created ? aws_eks_cluster.eks_cluster[0].identity[0].oidc[0].issuer : ""
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = var.is_eks_cluster_created ? aws_eks_cluster.eks_cluster[0].name : ""
}

output "cluster_version" {
  description = "Kubernetes version of the EKS cluster"
  value       = var.is_eks_cluster_created ? aws_eks_cluster.eks_cluster[0].version : ""
}

