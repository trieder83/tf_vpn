terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

resource "aws_instance" "wg_vpn" {
  ami           = "ami-0d527b8c289b4af7f" # Ubuntu Server 20.04 LTS (HVM), SSD Volume Type
  instance_type = "t2.micro"
  availability_zone = var.aws_availability_zone_a
  #associate_public_ip_address
  #iam_instance_profile
  #security_groups
  #subnet_id

  provisioner "file" {
    source      = "setup_wg.sh"
    destination = "/tmp/setup_wg.sh"

    connection {
      type     = "ssh"
      user     = "ubuntu"
      host     = self.public_ip
      private_key = "${file(var.ssh_wg_key_private)}"
    }

  }

  provisioner "remote-exec" {
      inline = [
      "chmod +x /tmp/setup_wg.sh",
      "/tmp/setup_wg.sh ${self.public_ip}"
    ]
    connection {
      type     = "ssh"
      user     = "ubuntu"
      host     = self.public_ip
      private_key = "${file(var.ssh_wg_key_private)}"
    }
  }


  depends_on = [
    module.vpc.main_vpc,
  ]

  tags = {
    env = "tftest"
  }
}
