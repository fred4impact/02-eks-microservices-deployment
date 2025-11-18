
data "tls_certificate" "eks_cluster" {
  url = "https://${module.eks.cluster_endpoint}"
}

data "aws_eks_cluster_auth" "eks_cluster" {
  name = module.eks.cluster_id
}

data "aws_iam_policy_document" "eks_oidc_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-test"]
    }

    principals {
      type        = "Service"
      identifiers = [aws_iam_openid_connect_provider.eks_oidc_provider.arn]
    }
  }
}

