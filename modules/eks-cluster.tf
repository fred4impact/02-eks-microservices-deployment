# Create cluster only if is_eks_cluster_created is true
resource "aws_eks_cluster" "eks_cluster" {
  count = var.is_eks_cluster_created == true ? 1 : 0

  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role[count.index].arn

  version = var.cluster_version

  vpc_config {
    subnet_ids = aws_subnet.private_subnets[1].id, aws_subnet.private_subnets[2].id]
    endpoint_private_access = var.private_endpoint_access
    endpoint_public_access  = var.public_endpoint_access

    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }

  access_config {
    authentication_mode = "CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  tags = {
    Name        = var.cluster_name
    Environment = var.environment
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy]

}

# OIDC Provider for EKS Cluster
resource "aws_iam_openid_connect_provide" "eks_oidc" {
    client_id_list  = ["sts.amazonaws.com"]
    thumbprint_list = [data.tls_certificate.eks_certificate.certificates[0].sha1_fingerprint]
   
    url             = data.tls_certificate.eks_certificate.url

   depends_on = [aws_eks_cluster.eks_cluster]
}

# eks-addons
resource "aws_eks_addon" "eks-addons" {
 for_each = { for idx, addon in var.addons : idx => addon }

  cluster_name = aws_eks_cluster.eks_cluster[0].name
  addon_name   = each.value.addon_name
  addon_version = eaxch.value.addon_version

  depends_on = [
    aws_eks_node_group.on_demand_nodegroup,
    aws_eks_node_group.spot_nodegroup
    ]
}   


#ON - Demand Node Group    
resource "aws_eks_node_group" "on_demand_nodegroup" {
 
  cluster_name    = aws_eks_cluster.eks_cluster[0].name
  node_group_name = "${var.cluster_name}-ondemand-nodegroup"

  node_role_arn   = aws_iam_role.eks_nodegroup_role[0].arn
 
  subnet_ids      = aws_subnet.private_subnets[0].id, aws_subnet.private_subnets[1].id, aws_subnet.private_subnets[2].id]

  scaling_config {
    desired_size = var.on_demand_desired_capacity
    max_size     = var.on_demand_max_size
    min_size     = var.on_demand_min_size
  }

  instance_types = var.on_demand_instance_types

#   ami_type       = var.ami_type
#   disk_size      = var.nodegroup_disk_size
  capacity_type  = "ON_DEMAND"
  labels = {
    "type" = "ondemand"
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
    Name        = "${var.cluster_name}-ondemand-nodegroup"
    Environment = var.environment
  }

  tags_all = { 
    "kubernetes.io/cluster/${var.cluster_name}" = "owned" 
     "Name" = "${var.cluster_name}-on-demand-nodes"
  }


  depends_on = [aws_eks_cluster.eks_cluster]
  
}

#ON-SPOT Demand Node Group Creation is handled in another module   
resource "aws_eks_node_group" "spot_nodegroup" {        
    cluster_name    = aws_eks_cluster.eks_cluster[0].name
    node_group_name = "${var.cluster_name}-spot-nodegroup"
    
    node_role_arn   = aws_iam_role.eks_nodegroup_role[0].arn
    
    subnet_ids      = [aws_subnet.private_subnets[0].id, aws_subnet.private_subnets[1].id, aws_subnet.private_subnets[2].id]
    
    scaling_config {
        desired_size = var.spot_desired_capacity
        max_size     = var.spot_max_size
        min_size     = var.spot_min_size
    }
    
    instance_types = var.spot_instance_types    

    capacity_type  = "SPOT"
    labels = {
        "type" = "spot"
    }   
    update_config {
        max_unavailable = 1
    }
    tags = {
        Name        = "${var.cluster_name}-spot-nodegroup"
        Environment = var.environment
    }
    tags_all = { 
        "kubernetes.io/cluster/${var.cluster_name}" = "owned" 
        "Name" = "${var.cluster_name}-spot-nodes"
    }
    depends_on = [aws_eks_cluster.eks_cluster]
}