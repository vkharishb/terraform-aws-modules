variable "bucket_name" {
  description = "S3 bucket name (must be globally unique)"
  type        = string
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "versioning" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}