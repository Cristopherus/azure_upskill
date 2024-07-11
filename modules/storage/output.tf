output "storage_account" {
  value = azurerm_storage_account.this
}

output "container_name" {
  value = azurerm_storage_container.this.name
}
