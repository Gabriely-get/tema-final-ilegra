variable "get_security_groups" {
  type    = list(string)
  default = ["sg-06b61c37c8d20d0d4"]

  validation {
    condition     = length(var.get_security_groups) > 0
    error_message = "The security group list should not be empty"
  }

}

variable "get_vpc_subnets" {
  type    = list(string)
  default = ["subnet-0fba352256e5e2443", "subnet-087a2c9f9f6a5b054"]
}

variable "get_vpc_id" {
  type    = string
  default = "vpc-061fbde2755f08de2"
}