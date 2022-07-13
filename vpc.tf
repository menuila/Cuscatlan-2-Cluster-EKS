#Definir variable REGION
variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}

# Definir proveedor
provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

locals {
  #cluster_deployment = "deployment-eks-${random_string.suffix.result}"
  cluster_deployment = "deployment-cluster"
  cluster_development = "development-cluster"

}

#resource "random_string" "suffix" {
#  length  = 8
#  special = false
#}

#Configuracion VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name                 = "devops-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
  public_subnets       = ["10.0.6.0/24", "10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_deployment}" = "shared"
    "kubernetes.io/cluster/${local.cluster_development}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_deployment}" = "shared"
    "kubernetes.io/cluster/${local.cluster_development}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_deployment}" = "shared"
    "kubernetes.io/cluster/${local.cluster_development}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}
