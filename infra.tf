# Create resource group.
resource "azurerm_resource_group" "rg_faks" {
  name     = "rg-${var.prefix}"
  location = var.region
}

# Define networking.
resource "azurerm_virtual_network" "faks_vnet" {
  name                = "${var.prefix}-vnet"
  location            = azurerm_resource_group.rg_faks.location
  resource_group_name = azurerm_resource_group.rg_faks.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "faks_internal_subnet" {
  name                 = "${var.prefix}-internal-subnet"
  virtual_network_name = azurerm_virtual_network.faks_vnet.name
  resource_group_name  = azurerm_resource_group.rg_faks.name
  address_prefixes     = ["10.1.0.0/22"]
}