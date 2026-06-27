# resource "azurerm_linux_virtual_machine_scale_set" "drupal_vmss" {
#   name                = "drupal-vmss"
#   location            = azurerm_resource_group.drupal_rg.location
#   resource_group_name = azurerm_resource_group.drupal_rg.name
#   sku                 = "Standard_GS1"
#   instances           = 2
#   admin_username      = var.admin_username
#   zones               = ["1", "2"]
#   zone_balance        = true
#   upgrade_mode        = "Automatic"
#
#   admin_ssh_key {
#     username   = var.admin_username
#     public_key = file("~/.ssh/drupal_key.pub")
#   }
#
#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-focal"
#     sku       = "20_04-lts"
#     version   = "latest"
#   }
#
#   os_disk {
#     storage_account_type = "Premium_LRS"
#     caching              = "ReadWrite"
#   }
#
#   network_interface {
#     name    = "drupal-vmss-nic"
#     primary = true
#
#     ip_configuration {
#       name      = "internal"
#       primary   = true
#       subnet_id = azurerm_subnet.app_subnet_1.id
#     }
#   }
#
#   tags = {
#     role        = "drupal-vmss"
#     environment = 
#   }
# }
#
# resource "azurerm_monitor_autoscale_setting" "drupal_autoscale" {
#   name                = "drupal-autoscale"
#   resource_group_name = azurerm_resource_group.drupal_rg.name
#   location            = azurerm_resource_group.drupal_rg.location
#   target_resource_id  = azurerm_linux_virtual_machine_scale_set.drupal_vmss.id
#
#   profile {
#     name = "default"
#
#     capacity {
#       default = 2
#       minimum = 2
#       maximum = 5
#     }
#
#     rule {
#       metric_trigger {
#         metric_name        = "Percentage CPU"
#         metric_resource_id = azurerm_linux_virtual_machine_scale_set.drupal_vmss.id
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "GreaterThan"
#         threshold          = 75
#       }
#
#       scale_action {
#         direction = "Increase"
#         type      = "ChangeCount"
#         value     = "1"
#         cooldown  = "PT5M"
#       }
#     }
#
#     rule {
#       metric_trigger {
#         metric_name        = "Percentage CPU"
#         metric_resource_id = azurerm_linux_virtual_machine_scale_set.drupal_vmss.id
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "LessThan"
#         threshold          = 25
#       }
#
#       scale_action {
#         direction = "Decrease"
#         type      = "ChangeCount"
#         value     = "1"
#         cooldown  = "PT5M"
#       }
#     }
#   }
# }