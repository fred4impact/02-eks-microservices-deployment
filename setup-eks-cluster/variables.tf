
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "environment" {
  description = "Environment tag (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "public_subnet_count" {
  description = "Number of public subnets to create"
  type        = number
  default     = 2
}

variable "public_subnet_cidrs" {
  description = "List of CIDRs for public subnets"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "public_availability_zone" {
  description = "List of AZs for public subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "private_subnet_count" {
  description = "Number of private subnets to create"
  type        = number
  default     = 3
}

variable "public_subnet_name" {
  description = "Name prefix for public subnets"
  type        = string
  default     = "public"
}

variable "private_subnet_name" {
  description = "Name prefix for private subnets"
  type        = string
  default     = "private"
}

variable "eks-cluster-sg-name" {
  description = "Security group name for the EKS cluster (module expects this variable name)"
  type        = string
  default     = "eks-cluster-sg"
}

# EKS / IAM flags
variable "is_eks_cluster_role_created" {
  description = "Whether to create the EKS cluster IAM role"
  type        = bool
  default     = true
}

variable "is_eks_nodegroup_role_created" {
  description = "Whether to create IAM role for nodegroups"
  type        = bool
  default     = true
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "dev-eks-cluster"
}

variable "cluster_role_arn" {
  description = "If provided, use an existing cluster role instead of creating one"
  type        = string
  default     = ""
}

variable "is_eks_cluster_created" {
  description = "Whether to create the EKS cluster resources"
  type        = bool
  default     = true
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.28"
}

variable "private_endpoint_access" {
  description = "Whether the EKS endpoint should have private access"
  type        = bool
  default     = false
}

variable "public_endpoint_access" {
  description = "Whether the EKS endpoint should have public access"
  type        = bool
  default     = true
}

variable "addons" {
  description = "List of EKS addons to install"
  type = list(object({
    addon_name    = string
    addon_version = string
  }))
  default = []
}

# Nodegroup sizing
variable "on_demand_desired_capacity" {
  type    = number
  default = 2
}

variable "on_demand_max_size" {
  type    = number
  default = 3
}

variable "on_demand_min_size" {
  type    = number
  default = 1
}

variable "on_demand_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "spot_desired_capacity" {
  type    = number
  default = 0
}

variable "spot_max_size" {
  type    = number
  default = 0
}

variable "spot_min_size" {
  type    = number
  default = 0
}

variable "spot_instance_types" {
  type    = list(string)
  default = []
}

variable "nodegroup_name" {
  description = "Name for the nodegroup (deprecated/unused, kept for module compatibility)"
  type        = string
  default     = ""
}

variable "nodegroup_instance_types" {
  description = "Deprecated alias"
  type        = list(string)
  default     = ["t3.medium"]
}
