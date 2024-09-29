terraform {
  required_version = "1.8.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.3.0"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "= 1.2.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "= 1.14"
    }
  }
}


provider "azurerm" {
  features {}
}


provider "azuredevops" {
  org_service_url       = "https://dev.azure.com/kayleevo9x"
  personal_access_token = var.azure_devops_pat
}
