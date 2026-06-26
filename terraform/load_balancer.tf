resource "azurerm_public_ip" "agw_pip" {
  name                = "drupal-agw-pip"
  location            = azurerm_resource_group.drupal_rg.location
  resource_group_name = azurerm_resource_group.drupal_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

locals {
  backend_address_pool_name = "drupal-backend-pool"
  frontend_port_name        = "drupal-frontend-port"
  frontend_ip_config_name   = "drupal-frontend-ip"
  http_setting_name         = "drupal-http-setting"
  listener_name             = "drupal-http-listener"
  request_routing_rule_name = "drupal-routing-rule"
  health_probe_name         = "drupal-health-probe"
}

resource "azurerm_application_gateway" "drupal_agw" {
  name                = "drupal-app-gateway"
  resource_group_name = azurerm_resource_group.drupal_rg.name
  location            = azurerm_resource_group.drupal_rg.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20220101"
  }

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = azurerm_subnet.gateway_subnet.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_config_name
    public_ip_address_id = azurerm_public_ip.agw_pip.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
    ip_addresses = [
      for nic in azurerm_network_interface.app_nic : nic.ip_configuration[0].private_ip_address
    ]
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    probe_name            = local.health_probe_name
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_config_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = 1
  }

  probe {
    name                = local.health_probe_name
    host                = "127.0.0.1"
    interval            = 30
    path                = "/user/login"
    protocol            = "Http"
    timeout             = 30
    unhealthy_threshold = 3
  }
}