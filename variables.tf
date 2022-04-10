variable "aws_availability_zone_a"  {
  description = "first availability_zone"
  type = string
  default = "eu-central-1a"
}
variable "aws_availability_zone_b"  {
  description = "first availability_zone"
  type = string
  default = "eu-central-1b"
}


variable "ssh_wg_key_private" {
  description = "ssh private key name"
  type = string
  default = "wg_vpn.key"
}

variable "instance_vpn_name" {
  default = "wgvpn001"
}

