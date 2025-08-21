variable "name_prefix" {
  type = string
  default = "Test"
}

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

variable "key_name" {
  type    = string
  default = "sandbox"
}

variable "user_name" {
  type    = string
  default = "Karim"
}

variable "asg_max_size" {
  type    = number
  default = 2
}

variable "asg_min_size" {
  type    = number
  default = 2
}

variable "asg_health_check_grace_period" {
  type    = number
  default = 400
}

variable "asg_health_check_type" {
  type    = string
  default = "ELB"
}

variable "asg_desired_capacity" {
  type    = number
  default = 2
}

variable "asg_force_delete" {
  type    = bool
  default = true
}

variable "asg_min_healthy_percentage" {
  type    = number
  default = 40
}

variable "asg_max_healthy_percentage" {
  type    = number
  default = 100
}

variable "ec2_sg_name" {
  type    = string
  default = "Karim-EC2-SG"
}

variable "alb_sg_name" {
  type    = string
  default = "Karim-ALB-SG"
}

variable "alb_egress_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "target_group_name" {
  type    = string
  default = "nginx-tg"
}

variable "target_group_port" {
  type    = number
  default = 80
}

variable "target_group_protocol" {
  type    = string
  default = "HTTP"
}

variable "tg_health_path" {
  type    = string
  default = "/"
}

variable "tg_health_interval" {
  type    = number
  default = 30
}

variable "tg_health_timeout" {
  type    = number
  default = 5
}

variable "tg_health_healthy_threshold" {
  type    = number
  default = 5
}

variable "tg_health_unhealthy_threshold" {
  type    = number
  default = 2
}

variable "tg_health_matcher" {
  type    = string
  default = "200"
}

variable "lb_listener_port" {
  type    = number
  default = 80
}

variable "lb_listener_protocol" {
  type    = string
  default = "HTTP"
}

variable "load_balancer_name" {
  type    = string
  default = "k-load-balancer"
}

variable "load_balancer_internal" {
  type    = bool
  default = false
}

variable "load_balancer_type" {
  type    = string
  default = "application"
}

variable "load_balancer_ip_address_type" {
  type    = string
  default = "ipv4"
}

variable "load_balancer_tag_name" {
  type    = string
  default = "Load_Balance"
}