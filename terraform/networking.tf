resource "azurerm_resource_group" "drupal_rg" {
  name     = var.resource_group_name
  location = var.location_primary
}

resource "azurerm_virtual_network" "drupal_vnet" {
  name                = "drupal-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.drupal_rg.location
  resource_group_name = azurerm_resource_group.drupal_rg.name
}

resource "azurerm_subnet" "app_subnet_1" {
  name                 = "app-subnet-zone1"
  resource_group_name  = azurerm_resource_group.drupal_rg.name
  virtual_network_name = azurerm_virtual_network.drupal_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "app_subnet_2" {
  name                 = "app-subnet-zone2"
  resource_group_name  = azurerm_resource_group.drupal_rg.name
  virtual_network_name = azurerm_virtual_network.drupal_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "db_subnet" {
  name                 = "db-subnet"
  resource_group_name  = azurerm_resource_group.drupal_rg.name
  virtual_network_name = azurerm_virtual_network.drupal_vnet.name
  address_prefixes     = ["10.0.3.0/24"]
  service_endpoints    = ["Microsoft.Sql"]

  delegation {
    name = "mysql-delegation"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

resource "azurerm_subnet" "gateway_subnet" {
  name                 = "gateway-subnet"
  resource_group_name  = azurerm_resource_group.drupal_rg.name
  virtual_network_name = azurerm_virtual_network.drupal_vnet.name
  address_prefixes     = ["10.0.4.0/24"]
}