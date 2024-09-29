terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.prefix}-rg"
  location = "East US"
}

resource "azurerm_service_plan" "asp" {
  name                = "${local.prefix}-asp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "linux_webapp" {
  name                          = "${local.prefix}-asp"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  service_plan_id               = azurerm_service_plan.asp.id
  public_network_access_enabled = true
  tags                          = local.tags

  site_config {
    application_stack {
      java_version        = 8
      java_server         = "JBOSSEAP"
      java_server_version = "7"
      #To list all the available stacks, run az webapp list-runtimes --linux
    }
  }
}
