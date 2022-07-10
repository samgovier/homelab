locals {
  location = azurerm_resource_group.ncus-govi-test.location
  rgname   = azurerm_resource_group.ncus-govi-test.name
}

resource "azurerm_network_security_group" "ncus-govi-test_NSG" {
  name                = "ncus-govi-test_NSG"
  location            = local.location
  resource_group_name = local.rgname
  tags                = var.common_tags
}

resource "azurerm_virtual_network" "ncus-govi-test_VNET" {
  name                = "ncus-govi-test_VNET"
  location            = local.location
  resource_group_name = local.rgname
  address_space       = [var.vnet_address_space]
  tags                = var.common_tags
}

resource "azurerm_subnet" "ncus-govi-test_DEFAULT-SUBNET" {
  name                 = "ncus-govi-test_DEFAULT-SUBNET"
  resource_group_name  = local.rgname
  virtual_network_name = azurerm_virtual_network.ncus-govi-test_VNET.name
  address_prefixes     = [var.default_subnet_address_space]
}

resource "azurerm_subnet" "ncus-govi-test_CONTAINER-SUBNET" {
  name                 = "ncus-govi-test_CONTAINER-SUBNET"
  resource_group_name  = local.rgname
  virtual_network_name = azurerm_virtual_network.ncus-govi-test_VNET.name
  address_prefixes     = [var.container_subnet_address_space]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "ncus-govi-test_VNGATEWAY-SUBNET" {
  name                 = "ncus-govi-test_VNGATEWAY-SUBNET"
  resource_group_name  = local.rgname
  virtual_network_name = azurerm_virtual_network.ncus-govi-test_VNET.name
  address_prefixes     = [var.vngateway_subnet_address_space]
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.ncus-govi-test_DEFAULT-SUBNET.id
  network_security_group_id = azurerm_network_security_group.ncus-govi-test_NSG.id
}

resource "azurerm_network_profile" "ncus-govi-test_CONTAINER-NP" {
  name                = "ncus-govi-test_CONTAINER-NP"
  location            = local.location
  resource_group_name = local.rgname

  container_network_interface {
    name = "ncus-govi-test_CONTAINER_NIC"

    ip_configuration {
      name      = "ncus-govi-test_CONTAINER_NIC_IP_CONFIG"
      subnet_id = azurerm_subnet.ncus-govi-test_CONTAINER-SUBNET.id
    }
  }
}

resource "azurerm_public_ip" "ncus-govi-test_VPN-PIP" {
  name                = "ncus-govi-test_VPN-PIP"
  location            = local.location
  resource_group_name = local.rgname

  allocation_method = "Dynamic"
}

# Point-to-Site VPN gateway for accessing and testing containers
resource "azurerm_virtual_network_gateway" "ncus-govi-test_VNG" {
  name                = "ncus-govi-test_VNG"
  location            = local.location
  resource_group_name = local.rgname
  tags                = var.common_tags

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.ncus-govi-test_VPN-PIP.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.ncus-govi-test_VNGATEWAY-SUBNET.id
  }
}