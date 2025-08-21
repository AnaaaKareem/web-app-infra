variable "iam_ec2_arn" {
  type = string
}

variable "s3_bucket_name" {
  type    = string
  default = "karim-bucket-terraform-test-9"
}

variable "s3_bucket_tag_name" {
  type    = string
  default = "Karim"
}

variable "s3_bucket_versioning_status" {
  type    = string
  default = "Enabled"
}

variable "s3_bucket_sse_algorithm" {
  type    = string
  default = "AES256"
}

variable "s3_block_public_acls" {
  type    = bool
  default = true
}

variable "s3_block_public_policy" {
  type    = bool
  default = true
}

variable "s3_ignore_public_acls" {
  type    = bool
  default = true
}

variable "s3_restrict_public_buckets" {
  type    = bool
  default = true
}