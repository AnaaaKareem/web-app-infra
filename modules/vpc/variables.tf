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

variable "public_subnet_name_prefix" {
  type    = string
  default = "Karim Public Subnet"
}

variable "private_subnet_name_prefix" {
  type    = string
  default = "Karim Private Subnet"
}

variable "igw_name" {
  type    = string
  default = "Karim-igw"
}

variable "eip_domain" {
  type    = string
  default = "vpc"
}

variable "eip_name" {
  type    = string
  default = "nat-eip"
}

variable "ngw_name" {
  type    = string
  default = "Karim-ngw"
}

variable "public_route_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "private_route_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "public_rt_name" {
  type    = string
  default = "Karim-pub-rt"
}

variable "private_rt_name" {
  type    = string
  default = "Karim-prv-rt"
}
