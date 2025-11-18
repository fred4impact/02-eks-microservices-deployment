
module "eks" {
  source = "../module"

  # VPC / networking
  vpc_cidr                 = var.vpc_cidr
  environment              = var.environment
  public_subnet_count      = var.public_subnet_count
  public_subnet_cidrs      = var.public_subnet_cidrs
  public_availability_zone = var.public_availability_zone
  private_subnet_count     = var.private_subnet_count
  public_subnet_name       = var.public_subnet_name
  private_subnet_name      = var.private_subnet_name

  # Security group name used by the module
  eks-cluster-sg-name = var.eks-cluster-sg-name

  # EKS cluster & nodegroup flags / settings
  cluster_name                  = var.cluster_name
  cluster_role_arn              = var.cluster_role_arn
  is_eks_cluster_role_created   = var.is_eks_cluster_role_created
  is_eks_nodegroup_role_created = var.is_eks_nodegroup_role_created
  is_eks_cluster_created        = var.is_eks_cluster_created
  cluster_version               = var.cluster_version
  private_endpoint_access       = var.private_endpoint_access
  public_endpoint_access        = var.public_endpoint_access

  # Addons and nodegroup sizing (optional)
  addons                     = var.addons
  nodegroup_name             = var.nodegroup_name
  nodegroup_instance_types   = var.nodegroup_instance_types
  on_demand_desired_capacity = var.on_demand_desired_capacity
  on_demand_max_size         = var.on_demand_max_size
  on_demand_min_size         = var.on_demand_min_size
  on_demand_instance_types   = var.on_demand_instance_types

  spot_desired_capacity = var.spot_desired_capacity
  spot_max_size         = var.spot_max_size
  spot_min_size         = var.spot_min_size
  spot_instance_types   = var.spot_instance_types

  # Pass through any other variables you need from this folder
}

// Useful outputs (if the module defines corresponding outputs)
output "cluster_id" {
  value       = try(module.eks.cluster_id, "")
  description = "EKS cluster id from the module"
}

output "cluster_endpoint" {
  value       = try(module.eks.cluster_endpoint, "")
  description = "EKS cluster endpoint"
}

output "cluster_oidc_issuer_url" {
  value       = try(module.eks.cluster_oidc_issuer_url, "")
  description = "OIDC issuer URL for the EKS cluster"
}

