variable "regions" {
  type    = list(string)
  default = ["eu-north-1", "eu-west-1"]
}

variable "access_key" {
  type    = string
}

variable "secret_key" {
  type    = string
}