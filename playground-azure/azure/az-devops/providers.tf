terraform {
  required_version = "1.11.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.27.0"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "= 1.9.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "2.3.0"
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
