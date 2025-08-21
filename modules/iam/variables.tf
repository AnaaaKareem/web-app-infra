variable "s3_arn" {
  type = string
}

variable "rds_arn" {
  type = string
}

variable "ec2_role_name" {
  type    = string
  default = "EC2-Role"
}

variable "ec2_policy_name" {
  type    = string
  default = "EC2-Policy"
}

variable "ec2_assume_service" {
  type    = string
  default = "s3.amazonaws.com"
}