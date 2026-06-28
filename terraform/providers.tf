terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "drupal-tfstate-rg"
    storage_account_name = "drupaltfstate2kc2"
    container_name       = "tfstate"
    key                  = "drupal.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}