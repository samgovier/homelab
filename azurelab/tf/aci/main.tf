resource "azurerm_container_group" "single-container-group" {
  name                = var.container_group_name
  location            = var.env_settings.location
  resource_group_name = var.env_settings.resource_group_name
  ip_address_type     = "Private"
  network_profile_id  = var.env_settings.network_profile_id

  # Must be Linux, as Windows containers are not supported on virtual networks
  os_type = "Linux"

  container {
    name   = var.container_settings.name
    image  = var.container_settings.image
    cpu    = var.container_settings.cpu
    memory = var.container_settings.memory

    ports {
      port = var.external_port.port
      protocol = var.external_port.protocol
    } 
    environment_variables = var.container_settings.env_vars
  }

  tags = var.tags
}