resource "azurerm_storage_account" "this" {
  name                     = var.container.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind

  tags = var.tags
}

resource "azurerm_storage_container" "this" {
  name                  = var.container.name
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = var.container.access_type
}
