variable "location_primary" {
  description = "Primary Azure region"
  type        = string
  default     = "canadacentral"
}

variable "location_secondary" {
  description = "Secondary Azure region for multi-zone deployment"
  type        = string
  default     = "France Central"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "drupal-production-rg"
}

variable "vm_size" {
  description = "Azure VM size for Drupal app servers"
  type        = string
  default     = "Standard_B2ps_v2"
}

variable "admin_username" {
  description = "Admin username for VMs"
  type        = string
  default     = "drupaladmin"
}

variable "db_admin_username" {
  description = "MySQL admin username"
  type        = string
  default     = "drupaldbadmin"
}

variable "db_admin_password" {
  description = "MySQL admin password"
  type        = string
  sensitive   = true
}

variable "app_server_count" {
  description = "Number of Drupal application servers"
  type        = number
  default     = 2
}