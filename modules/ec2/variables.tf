variable "name" {
  description = "Instance name"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "Security groups"
  type        = list(string)
}

variable "os_type" {
  description = "Operating system (linux/windows)"
  type        = string
}

variable "key_name" {
  description = "Key pair name"
  type        = string
}

variable "user_data_enabled" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "associate_public_ip" {
  type    = bool
  default = true
  
}

variable "iam_instance_profile" {
  
}

variable "root_volume_size" {
  
}