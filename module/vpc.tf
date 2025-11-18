locals {
  cluster_name = var.cluster_name
}

# Create VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.cluster_name}-vpc"
    evn  = var.environment
  }

}

# Create Internet Gateway
resource "aws_internet_gateway" "nameigw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name                                          = "${local.cluster_name}-igw"
    evn                                           = var.environment
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
  }

  depends_on = [aws_vpc.vpc]

}

# Create Public Subnets
resource "aws_subnet" "public_subnet" {
  count      = var.public_subnet_count
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.public_subnet_cidrs, count.index)
  #   availability_zone       = data.aws_availability_zones.available.names[0]
  availability_zone       = element(var.public_availability_zone, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name                                          = "${var.public_subnet_name}-${count.index + 1}"
    evn                                           = var.environment
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
    "kubernetes.io/role/elb"                      = "1"

  }

  depends_on = [aws_vpc.vpc]

}

# Create Private Subnets
resource "aws_subnet" "private_subnet" {
  count             = var.private_subnet_count
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, count.index + var.private_subnet_count)
  availability_zone = element(var.public_availability_zone, count.index)

  tags = {
    Name                                          = "${var.private_subnet_name}-${count.index + 1}"
    evn                                           = var.environment
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
    "kubernetes.io/role/internal-elb"             = "1"

  }

  depends_on = [aws_vpc.vpc]

}

# Create Public Route Table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nameigw.id
  }

  tags = {
    Name = "${local.cluster_name}-public-rt"
    evn  = var.environment
  }

  depends_on = [aws_internet_gateway.nameigw]

}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public-rt-assoc" {
  count          = var.public_subnet_count
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "${local.cluster_name}-private-rt"
    evn  = var.environment
  }

  depends_on = [aws_vpc.vpc]

}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private-rt-assoc" {
  count          = var.private_subnet_count
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private-rt.id
}

# Allocate Elastic IP for NAT Gateway
resource "aws_eip" "nat-gw-ip" {
  domain = "vpc"

  tags = {
    Name = "nat-gw-ip"
    evn  = var.environment
  }

  depends_on = [aws_vpc.vpc]
}

# Create NAT Gateway in the first Public Subnet
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat-gw-ip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
  depends_on    = [aws_subnet.public_subnet, aws_eip.nat-gw-ip]
  tags = {
    Name = "${local.cluster_name}-nat-gw"
    evn  = var.environment
  }
}

# Security Group for VPC Endpoints
resource "aws_security_group" "eks-cluster-sg" {
  name        = var.eks-cluster-sg-name
  description = "Security group for VPC endpoints"
  vpc_id      = aws_vpc.vpc.id


  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block] # use specific CIDR block of the VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.eks-cluster-sg-name
    evn  = var.environment
  }
}

