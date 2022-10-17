locals {
  workshop_user_lower_case = lower(var.workshop_user)
}

resource "azurerm_resource_group" "workshop" {
  name     = "rg-workshop-${local.workshop_user_lower_case}"
  location = var.location
  tags = {
    purpose       = "workshop"
    team          = "know-it"
    workshop_user = var.workshop_user
  }
}

resource "azurerm_virtual_network" "workshop" {
  name                = "vnet-workshop-${local.workshop_user_lower_case}"
  location            = azurerm_resource_group.workshop.location
  resource_group_name = azurerm_resource_group.workshop.name
  address_space       = ["10.0.0.0/16"]
}


resource "azurerm_subnet" "subnet1" {
  name                 = "sn-workshop-subnet1-${local.workshop_user_lower_case}"
  resource_group_name  = azurerm_resource_group.workshop.name
  virtual_network_name = azurerm_virtual_network.workshop.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "sn-workshop-subnet2-${local.workshop_user_lower_case}"
  resource_group_name  = azurerm_resource_group.workshop.name
  virtual_network_name = azurerm_virtual_network.workshop.name
  address_prefixes     = ["10.0.2.0/24"]
}
