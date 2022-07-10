variable "vnet_address_space" {
  type = string
}

variable "default_subnet_address_space" {
  type = string
}

variable "container_subnet_address_space" {
  type = string
}

variable "vngateway_subnet_address_space" {
  type = string
}

variable "common_tags" {
  type = map(any)
  default = {
    terraform   = true
    environment = "Development"
  }
}