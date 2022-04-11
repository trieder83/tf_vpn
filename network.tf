resource "aws_security_group" "ssh-allowed" {
    vpc_id = "${module.vpc.vpc_id}"
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        // This means, all ip address are allowed to ssh ! 
        // Do not do it in the production. 
        // Put your office or home address in it!
        cidr_blocks = ["0.0.0.0/0"]
    }
    //wireguard default port
    ingress {
        from_port = 51820
        to_port = 51820
        protocol = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        name = "ssh-allowed"
        env = "tftest"
    }
    depends_on = [
      module.vpc.main_vpc,
    ]
}

resource "aws_internet_gateway" "gw" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "main"
    env = "tftest"
  }
}


