resource "azurerm_resource_group" "ncus-govi-test" {
  name     = "ncus-govi-test"
  location = "northcentralus"
  tags     = var.common_tags
}