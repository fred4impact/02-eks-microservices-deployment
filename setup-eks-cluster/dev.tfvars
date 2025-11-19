
# Development environment variables for the EKS setup
vpc_cidr                 = "10.0.0.0/16"
environment              = "dev"
public_subnet_count      = 2
public_subnet_cidrs      = ["10.0.0.0/24", "10.0.1.0/24"]
public_availability_zone = ["us-east-1a", "us-east-1b"]
private_subnet_count     = 3
public_subnet_name       = "public"
private_subnet_name      = "private"

# Security group name for EKS cluster
eks-cluster-sg-name = "eks-cluster-sg"

cluster_name                  = "dev-eks-cluster"
is_eks_cluster_role_created   = true
is_eks_nodegroup_role_created = true
is_eks_cluster_created        = true
cluster_version               = "1.28"
private_endpoint_access       = false
public_endpoint_access        = true

addons = []

# On-demand nodegroup sizing
on_demand_desired_capacity = 2
on_demand_max_size         = 3
on_demand_min_size         = 1
on_demand_instance_types   = ["t3.medium"]

# Spot nodegroup (disabled by default in dev - set to 0 to disable)
# Using multiple instance types increases spot availability
spot_desired_capacity = 1
spot_max_size         = 2
spot_min_size         = 1
spot_instance_types   = ["t3.medium", "t3.small", "t3a.medium", "t3a.small"]

