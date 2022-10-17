resource "azurerm_public_ip" "workshop" {
  name                = "pip-workshop-${local.workshop_user_lower_case}"
  location            = azurerm_resource_group.workshop.location
  resource_group_name = azurerm_resource_group.workshop.name
  allocation_method   = "Static"
  domain_name_label   = local.domain_name_label
}

resource "azurerm_lb" "workshop" {
  name                = "lb-workshop-${local.workshop_user_lower_case}"
  location            = azurerm_resource_group.workshop.location
  resource_group_name = azurerm_resource_group.workshop.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.workshop.id
  }
}

resource "azurerm_lb_backend_address_pool" "workshop" {
  name            = "lbbp-workshop-${local.workshop_user_lower_case}"
  loadbalancer_id = azurerm_lb.workshop.id
}

resource "azurerm_lb_probe" "workshop" {
  loadbalancer_id     = azurerm_lb.workshop.id
  name                = "http"
  port                = 8080
  protocol            = "Http"
  request_path        = "/"
  interval_in_seconds = "5"
}