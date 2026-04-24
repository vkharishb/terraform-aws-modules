variable "cidr_block" {
  description = "VPC CIDR"
  type        = string

  validation {
    condition     = can(cidrnetmask(var.cidr_block))
    error_message = "Invalid CIDR block"
  }
}
