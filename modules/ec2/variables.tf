variable "ami" {
  type    = string
  default = "ami-042b4708b1d05f512"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "instance_name" {
  type    = string
  default = "Karim-web-server"
}

variable "availability_zones" {
  type = list(string)
  default = [ "eu-north-1a", "eu-north-1b" ]
}

variable "cidr_block" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}