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

variable "public_subnets" {
  description = "Optional public subnet CIDR blocks. If empty, subnets are generated from cidr_block."
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.public_subnets) == 0 || length(var.public_subnets) == var.az_count
    error_message = "public_subnets must be empty or have the same number of elements as az_count"
  }
}

variable "private_subnets" {
  description = "Optional private subnet CIDR blocks. If empty, subnets are generated from cidr_block."
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.private_subnets) == 0 || length(var.private_subnets) == var.az_count
    error_message = "private_subnets must be empty or have the same number of elements as az_count"
  }
}

variable "enable_flow_logs" {
  description = "Whether to create VPC flow logs."
  type        = bool
  default     = false
}

variable "cidr" {
  type = string
  default = "10.0.0.0/16"
}