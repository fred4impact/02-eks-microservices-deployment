
variable "vpc_cidr" {

}

variable "environment" {

}

variable "public_subnet_count" {
  default = 2
}

variable "public_subnet_cidrs" {
  type = list(string)
}
variable "public_availability_zone" {
  type = list(string)
}

variable "private_subnet_count" {

}
variable "public_subnet_name" {

}
variable "private_subnet_name" {

}

variable "eks-cluster-sg-name" {

}

variable "is_eks_cluster_role_created" {

}

variable "is_eks_nodegroup_role_created" {

}

variable "cluster_name" {

}
variable "cluster_role_arn" {

}
variable "is_eks_cluster_created" {

}
variable "cluster_version" {

}

variable "private_endpoint_access" {

}
variable "public_endpoint_access" {

}
variable "addons" {
  type = list(object({
    addon_name    = string
    addon_version = string
  }))
  default = []
}

variable "nodegroup_name" {

}
variable "nodegroup_instance_types" {

}
variable "on_demand_desired_capacity" {

}
variable "on_demand_max_size" {

}
variable "on_demand_min_size" {

}
variable "on_demand_instance_types" {

}

variable "spot_desired_capacity" {

}
variable "spot_max_size" {

}
variable "spot_min_size" {

}
variable "spot_instance_types" {

}
