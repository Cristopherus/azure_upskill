resource "azurerm_virtual_network" "this" {
  name                = var.tags.Name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.cidr
}

resource "azurerm_subnet" "this" {
  for_each = var.subnets

  name                 = "${var.tags.Name}-${each.key}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = each.value.cidr
}
