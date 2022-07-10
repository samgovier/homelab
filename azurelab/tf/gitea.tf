module "gitea_container" {
  source = "./aci"

  env_settings = {
    location            = azurerm_resource_group.ncus-govi-test.location
    resource_group_name = azurerm_resource_group.ncus-govi-test.name
    network_profile_id  = azurerm_network_profile.ncus-govi-test_CONTAINER-NP.id
  }

  container_group_name = "ncus-gitea-dev_CG"

  container_settings = {
    name   = "ncus-gitea-dev"
    image  = "gitea/gitea:1.16.9"
    cpu    = "0.5"
    memory = "1.5"
    env_vars = {
      USER_UID = 1000
      USER_GID = 1000
    }
  }

  external_port = {
    port = 443
    protocol = "TCP"
  }

  tags = var.common_tags
}