locals {
  cluster_name = cluster_name
}

resource "ramdom_integer" "random_surfix" {
  min = 10000
  max = 99999

}

# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  count = var.is_eks_cluster_role_created ? 1 : 0
  name  = "${local.cluster_name}-cluster-role-${ramdom_integer.random_surfix.result}"


  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role_policy.json
}

# Attach necessary policies to the EKS Cluster Role
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks_cluster_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}


# Attach necessary policies to the EKS Cluster Role
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSServicePolicy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

# IAM Role for EKS Node Group
resource "aws_iam_role" "eks_node_group_role" {

  count              = var.is_eks_nodegroup_role_created ? 1 : 0
  name               = "${local.cluster_name}-eks-node-group-role-${ramdom_integer.random_surfix.result}"
  assume_role_policy = data.aws_iam_policy_document.eks_node_group_assume_role_policy.json
}
# Attach necessary policies to the EKS Node Group Role
resource "aws_iam_role_policy_attachment" "eks_node_group_AmazonEKSWorkerNodePolicy" {
  count      = var.is_eks_nodegroup_role_created ? 1 : 0
  role       = aws_iam_role.eks_node_group_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# Attach necessary policies to the EKS Node Group Role
resource "aws_iam_role_policy_attachment" "eks_node_group_AmazonEKS_CNI_Policy" {
  count      = var.is_eks_nodegroup_role_created ? 1 : 0
  role       = aws_iam_role.eks_node_group_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# Attach necessary policies to the EKS Node Group Role
resource "aws_iam_role_policy_attachment" "eks_node_group_AmazonEKS_CNI_Policy" {
  count      = var.is_eks_nodegroup_role_created ? 1 : 0
  role       = aws_iam_role.eks_node_group_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

data "aws_iam_policy_document" "eks_cluster_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "eks_node_group_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

#AmazonEKSContainerRegistryReadOnly policy
resource "aws_iam_role_policy_attachment" "eks-AmazonEC2ContainerRegistryReadOnly" {
  count      = var.is_eks_nodegroup_role_created ? 1 : 0
  role       = aws_iam_role.eks_node_group_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

#AmazonEBSCSIDriverPolicy
resource "aws_iam_role_policy_attachment" "eks-AmazonEBSCSIDriverPolicy" {
  count      = var.is_eks_nodegroup_role_created ? 1 : 0
  role       = aws_iam_role.eks_node_group_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}
## OIDC Provider for EKS
resource "aws_iam_role" "eks_oidc_role" {
  name               = "eks_odic"
  assume_role_policy = data.aws_iam_policy_document.eks_oidc_assume_role_policy.json

}

resource "aws_iam_policy_document" "eks_oidc_assume_role_policy" {
  name = "eks-oidc-test-policy"

  policy_id = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks_oidc_provider.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${replace(aws_iam_openid_connect_provider.eks_oidc_provider.url, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-ebs-csi-driver-sa"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks-oidc-policy-attach" {
  role       = aws_iam_role.eks_oidc_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}
