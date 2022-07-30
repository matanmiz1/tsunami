module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.14"

  name = "${var.project_name}-vpc"
  azs  = ["${var.aws_region}b"]
  cidr = var.vpc_cidr

  private_subnets  = var.vpc_private_subnets
  public_subnets   = var.vpc_public_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true

  # Deploy one NAT Gateway
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
}
