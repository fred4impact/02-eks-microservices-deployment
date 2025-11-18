
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
