variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  type    = string
  default = "Karim_VPC"
}

variable "public_subnets" {
  type    = list(string)
  default = [ "10.0.1.0/24", "10.0.2.0/24" ]
}

variable "private_subnets" {
  type    = list(string)
  default = [ "10.0.3.0/24", "10.0.4.0/24" ]
}

variable "availability_zones" {
  type    = list(string)
  default = [ "eu-north-1a", "eu-north-1b" ]
}