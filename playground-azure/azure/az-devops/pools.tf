resource "azurerm_resource_group" "this" {
  name     = "${prefix}-azure-devops-rg"
  location = local.location
  tags     = local.tags
}

## Prerequisites
resource "azurerm_resource_provider_registration" "this" {
  name = "Microsoft.DevOpsInfrastructure"
}

resource "azurerm_role_definition" "devops_infrastructure_vnet_role" {
  name        = "Virtual Network Contributor for DevOpsInfrastructure"
  scope       = data.azurerm_subscription.current.id
  description = "Custom Role for Virtual Network Contributor for DevOpsInfrastructure"

  permissions {
    actions = [
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/virtualNetworks/subnets/serviceAssociationLinks/validate/action",
      "Microsoft.Network/virtualNetworks/subnets/serviceAssociationLinks/write",
      "Microsoft.Network/virtualNetworks/subnets/serviceAssociationLinks/delete"
    ]
  }
}

resource "azurerm_role_assignment" "devops_infrastructure_vnet_read" {
  scope                = data.terraform_remote_state.vnet.outputs.vnet.virtual_network_id
  role_definition_name = "Reader"
  principal_id         = data.azuread_service_principal.built_in_devops.object_id
}

resource "azurerm_role_assignment" "devops_infrastructure_vnet_contributor" {
  scope              = data.terraform_remote_state.vnet.outputs.vnet.virtual_network_id
  role_definition_id = azurerm_role_definition.devops_infrastructure_vnet_role.role_definition_resource_id
  principal_id       = data.azuread_service_principal.built_in_devops.object_id
}

resource "azurerm_dev_center" "this" {
  name                = "${local.prefix}-dev-center"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = local.tags
  depends_on          = [azurerm_resource_provider_registration.this]
}

resource "azurerm_dev_center_project" "this" {
  dev_center_id       = azurerm_dev_center.this.id
  name                = "${local.prefix}-dev-center-project"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = local.tags
}

## Managed DevOps Pools
## json scheme https://github.com/Azure/azure-resource-manager-schemas/blob/main/schemas/2024-04-04-preview/Microsoft.DevOpsInfrastructure.json
locals {
  devops_pools = {
    dev = {
      poolName = "development-pools"
      sku      = "Standard_DS1_v2"
      images = [{ wellKnownImageName = "ubuntu-22.04/latest"
        aliases = [
          "ubuntu-latest"
      ] }]
      maximumConcurrency = 5
      #subnetId           = 
      #identity_ids = []
      agentProfile = {
        kind                = "Stateful"
        gracePeriodTimeSpan = "00:10:00"
        maxAgentLifetime    = "02:00:00"
      }
    }
  }
  org_profile = {
    kind = "AzureDevOps"
    organizations = [{
      url      = "https://dev.azure.com/kayleevo9x/"
      projects = ["${local.prefix}"]
    }]
  }
}

resource "azapi_resource" "managed_devops_pool" {
  for_each = local.devops_pools
  name     = each.value.poolName
  type     = "Microsoft.DevOpsInfrastructure/pools@2024-04-04-preview"
  body = {
    properties = {
      #devCenterProjectResourceId = azurerm_dev_center_project.this.id
      maximumConcurrency  = each.value.maximumConcurrency
      organizationProfile = local.org_profile

      agentProfile = each.value.agentProfile
      fabricProfile = {
        sku = {
          name = each.value.sku
        }
        images = each.value.images

        networkProfile = {
          subnetId = each.value.subnetId
        }
        kind = "Vmss"
      }
    }
  }
  identity {
    type         = "UserAssigned"
    identity_ids = each.value.identity_ids
  }
  location   = azurerm_resource_group.this.location
  parent_id  = azurerm_resource_group.this.id
  tags       = local.tags
  depends_on = [azurerm_role_assignment.devops_infrastructure_vnet_contributor, azurerm_role_assignment.devops_infrastructure_vnet_read]
}
