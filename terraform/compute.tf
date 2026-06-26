resource "azurerm_public_ip" "app_vm_pip" {
  count               = var.app_server_count
  name                = "drupal-vm-pip-${count.index + 1}"
  location            = azurerm_resource_group.drupal_rg.location
  resource_group_name = azurerm_resource_group.drupal_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "app_nic" {
  count               = var.app_server_count
  name                = "drupal-nic-${count.index + 1}"
  location            = azurerm_resource_group.drupal_rg.location
  resource_group_name = azurerm_resource_group.drupal_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = count.index == 0 ? azurerm_subnet.app_subnet_1.id : azurerm_subnet.app_subnet_2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.app_vm_pip[count.index].id
  }
}

resource "azurerm_linux_virtual_machine" "drupal_app" {
  count               = var.app_server_count
  name                = "drupal-app-vm-${count.index + 1}"
  location            = azurerm_resource_group.drupal_rg.location
  resource_group_name = azurerm_resource_group.drupal_rg.name
  size                = var.vm_size
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.app_nic[count.index].id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("~/.ssh/drupal_key.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  tags = {
    role        = "drupal-app"
    environment = "production"
  }
}