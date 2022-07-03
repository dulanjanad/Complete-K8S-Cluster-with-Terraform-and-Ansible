data "aws_availability_zones" "available" {

}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = var.vpc_name
  cidr = var.cidr

  azs             = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  public_subnets  = [cidrsubnet(var.cidr, 8, 10), cidrsubnet(var.cidr, 8, 30)]
  private_subnets = [cidrsubnet(var.cidr, 8, 20), cidrsubnet(var.cidr, 8, 40)]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  tags = {
    Name        = "${var.vpc_name}-VPC"
    Environment = "dev"
  }

}