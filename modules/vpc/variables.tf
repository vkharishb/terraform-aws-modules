variable "name" {
  description = "Name prefix for resources"
  type        = string
}

variable "cidr_block" {
  description = "VPC CIDR"
  type        = string

  validation {
    condition     = can(cidrnetmask(var.cidr_block))
    error_message = "Invalid CIDR block"
  }
}

variable "az_count" {
  description = "Number of AZs to use"
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 2 && var.az_count <= 3
    error_message = "AZ count must be between 2 and 3"
  }
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "single_nat_gateway" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}