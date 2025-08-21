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

variable "db_publicly_accessible" {
  type    = bool
  default = false
}

variable "db_subnet_group_name" {
  type    = string
  default = "db-private-subnets"
}

variable "kms_enable_key_rotation" {
  type    = bool
  default = false
}

variable "kms_deletion_window_in_days" {
  type    = number
  default = 7
}

variable "rds_secret_name" {
  type    = string
  default = "k_db_rds_cred"
}

variable "db_sg_name" {
  type    = string
  default = "Karim-DB"
}

variable "db_app_key_name" {
  type    = string
  default = "sandbox"
}

variable "region" {
  type    = string
  default = "eu-north-1"
}

variable "db_app_name" {
  type    = string
  default = "DB"
}
