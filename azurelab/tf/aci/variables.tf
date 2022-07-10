variable "env_settings" {
  type = object({
    location            = string
    resource_group_name = string
    network_profile_id  = string
  })
}

variable "container_group_name" {
  type = string
}

variable "container_settings" {
  type = object({
    name     = string
    image    = string
    cpu      = string
    memory   = string
    env_vars = map(any)
    # volume?
  })
}

variable "external_port" {
    type = object({
      port = number
      protocol = string
  })
}

variable "tags" {
  type    = map(any)
  default = {}
}