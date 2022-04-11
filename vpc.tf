
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name = "main_vpc"
  cidr = "10.10.0.0/18"

  azs             = [var.aws_availability_zone_a]
  public_subnets = ["10.10.0.0/22"] #, "10.10.4.0/22"]
  private_subnets  = ["10.10.8.0/22", "10.10.12.0/22"]
  #intra_subnets

  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = true

  tags = {
    Terraform = "true"
    env = "tftest"
  }
}

module "eks_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name = "eks_vpc_a"
  cidr = "10.11.0.0/18"

  azs             = [var.aws_availability_zone_a]
  public_subnets = ["10.11.0.0/22"] #, "10.10.4.0/22"]
  private_subnets  = ["10.11.8.0/22"]
  #intra_subnets

  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = true

  tags = {
    Terraform = "true"
    env = "tftest"
  }
}

resource "aws_vpc_peering_connection" "peer_eks001" {
  #peer_owner_id = var.peer_owner_id
  peer_vpc_id   = module.vpc.vpc_id
  vpc_id        = module.eks_vpc.vpc_id
  auto_accept   = true

  tags = {
    Name = "VPC Peering between vpc and eks_vpc"
    env = "tftest"
  }
}

resource "aws_default_route_table" "main_route_table" {
  default_route_table_id = module.vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  route {
    cidr_block = "10.11.1.0/18"
    vpc_peering_connection_id = aws_vpc_peering_connection.peer_eks001.id
  }

  tags = {
    Name = "example"
  }
}
