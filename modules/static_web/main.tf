locals {
  static_index = split("/", var.container.static_index)[1]
}

resource "azurerm_storage_account" "this" {
  name                      = var.container.name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  account_kind              = var.account_kind
  enable_https_traffic_only = false

  static_website {
    index_document = local.static_index
  }

  tags = var.tags
}

data "azurerm_storage_account_blob_container_sas" "this" {
  connection_string = var.storage_account.primary_connection_string
  container_name    = var.container_name

  start  = "2018-03-21"
  expiry = "2025-03-21"

  permissions {
    read   = true
    add    = true
    create = true
    write  = true
    delete = true
    list   = true
  }
}

resource "azurerm_storage_blob" "this" {
  name                   = local.static_index
  storage_account_name   = azurerm_storage_account.this.name
  storage_container_name = "$web" #azurerm_storage_container.this.name
  type                   = "Block"
  content_type           = "text/html"
  source                 = "${path.root}/${var.container.static_index}"
  content_md5            = local_file.this.content_base64

  depends_on = [local_file.this]
}

data "template_file" "html_template" {
  template = file("${path.root}/${var.container.static_index}.tpl")

  vars = {
    sas_token            = data.azurerm_storage_account_blob_container_sas.this.sas
    storage_account_name = var.storage_account.name
    container_name       = var.container_name
  }

  depends_on = [azurerm_storage_account.this]
}

resource "local_file" "this" {
  content  = data.template_file.html_template.rendered
  filename = "${path.root}/${var.container.static_index}"
}
