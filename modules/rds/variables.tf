variable "db_allocated_storage" {
  type    = number
  default = 10
}

variable "db_max_allocated_storage" {
  type    = number
  default = 20
}

variable "db_name" {
  type    = string
  default = "mydb"
}

variable "db_engine" {
  type    = string
  default = "mysql"
}

variable "db_engine_version" {
  type    = string
  default = "8.0"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_username" {
  type      = string
  default   = "admin"
  sensitive = true
}

variable "db_password" {
  type      = string
  default = "VoisVois25"
  sensitive = true
}

variable "db_parameter_group_name" {
  type    = string
  default = "default.mysql8.0"
}

variable "db_skip_final_snapshot" {
  type    = bool
  default = true
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
  default = "t3.micro"
}

variable "pub_ids" {
  type = list(string)
}

variable "ec2sg" {
  type = string
}

variable "vpc_id" {
  type = string
}