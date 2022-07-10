terraform {
  required_version = ">= 1.2"
  required_providers {
    azurerm = {
      version = "3.13"
    }
  }
}

provider "azurerm" {
  features {}
}