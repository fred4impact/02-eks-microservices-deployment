provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = "~> 1.13.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.50.0"

    }
  }

  backend "s3" {
    bucket       = "02-micro-bilarn-tf-bucket-2025"
    key          = "eks-microservices/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}


