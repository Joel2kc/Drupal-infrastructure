output "application_gateway_public_ip" {
  description = "Public IP of the Application Gateway"
  value       = azurerm_public_ip.agw_pip.ip_address
}

output "drupal_vm_public_ips" {
  description = "Public IPs of Drupal application VMs"
  value       = [for pip in azurerm_public_ip.app_vm_pip : pip.ip_address]
}

output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.drupal_rg.name
}

output "vm1_ssh_command" {
  description = "SSH command to connect to VM1"
  value       = "ssh -i ~/.ssh/drupal_key drupaladmin@${azurerm_public_ip.app_vm_pip[0].ip_address}"
}

output "vm2_ssh_command" {
  description = "SSH command to connect to VM2"
  value       = "ssh -i ~/.ssh/drupal_key drupaladmin@${azurerm_public_ip.app_vm_pip[1].ip_address}"
}