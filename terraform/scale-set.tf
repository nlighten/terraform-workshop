locals {
  domain_name_label = "workshop-${var.team}-${local.workshop_user_lower_case}"
  cloud_config = templatefile("${path.module}/../config/cloud-config.tftpl", {
    workshop_user = var.workshop_user
    domain_label  = local.domain_name_label
  })
}

resource "azurerm_linux_virtual_machine_scale_set" "workshop" {
  name                            = "vmdfsdss-workshop-${local.workshop_user_lower_case}"
  resource_group_name             = azurerm_resource_group.workshop.name
  location                        = azurerm_resource_group.workshop.location
  sku                             = "Standard_B1s"
  instances                       = 2
  admin_username                  = "adminuser"
  admin_password                  = var.vm_password
  disable_password_authentication = false

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "workshop"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = azurerm_subnet.subnet1.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.workshop.id]
    }
  }

  user_data = base64encode(local.cloud_config)
}
