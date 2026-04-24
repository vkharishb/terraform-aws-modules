variable "cidr" {
  description = "VPC CIDR block for the example"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.cidr))
    error_message = "Invalid CIDR block"
  }
}
