

resource "azurerm_resource_group" "vnet" {
  location = local.location
  name     = "${local.prefix}-vnet-rg"
}

module "vnet" {
  source  = "Azure/vnet/azurerm"
  version = "4.1.0"

  use_for_each        = true
  vnet_location       = azurerm_resource_group.vnet.location
  vnet_name           = "${local.prefix}-vnet"
  resource_group_name = azurerm_resource_group.vnet.name
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["generic", "webapp"]

  subnet_delegation = {
    webapp = {
      "Microsoft.Web/serverFarms" = {
        service_name = "Microsoft.Web/serverFarms"
        service_actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action",
          "Microsoft.Network/virtualNetworks/subnets/action",
        ]
      }
    }
  }
}

