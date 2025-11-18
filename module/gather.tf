# Data sources for EKS cluster information
data "tls_certificate" "eks_cluster" {
  count = var.is_eks_cluster_created ? 1 : 0
  url   = aws_eks_cluster.eks_cluster[0].identity[0].oidc[0].issuer
}

data "aws_eks_cluster_auth" "eks_cluster" {
  count = var.is_eks_cluster_created ? 1 : 0
  name  = aws_eks_cluster.eks_cluster[0].name
}

