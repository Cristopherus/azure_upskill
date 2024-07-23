provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "this" {
  name     = var.tags.Name
  location = var.location
}

# module "network" {
#   source = "./modules/network"

#   location            = var.location
#   resource_group_name = azurerm_resource_group.this.name
#   cidr                = var.network.cidr
#   subnets             = var.network.subnets

#   tags = var.tags
# }

module "containers" {
  source   = "./modules/storage"
  for_each = var.containers

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  container           = each.value

  tags = var.tags
}

module "static_web" {
  source = "./modules/static_web"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  container           = var.static_web
  storage_account     = module.containers["upload"].storage_account
  container_name      = module.containers["upload"].container_name

  tags = var.tags
}

module "function" {
  source = "./modules/function_app"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  function_name       = var.function_name

  tags = var.tags
}

output "web_host" {
  value = module.static_web.primary_web_host
}
