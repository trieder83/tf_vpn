
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
