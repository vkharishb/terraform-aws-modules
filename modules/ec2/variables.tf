variable "name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
  default = "t3.micro"
}

variable "subnet_id" {
  type = string
}


variable "iam_role_name" {
  type    = string
  default = null
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "create_iam_role" {
  type    = bool
  default = false
}

variable "user_data" {
  type    = string
  default = null
}

variable "tags" {
  type = map(string)
}