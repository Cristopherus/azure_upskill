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

# resource "azurerm_storage_container" "this" {
#   name                  = var.container.name
#   storage_account_name  = azurerm_storage_account.this.name
#   container_access_type = var.container.access_type
# }

# resource "azurerm_storage_account_sas" "this" {
#   storage_account_name = azurerm_storage_account.storage.name
#   https_only           = true
#   start                = formatdate("YYYY-MM-DD", timestamp())
#   expiry               = formatdate("YYYY-MM-DD", timeadd(timestamp(), "24h"))
#   permissions          = "racwdl"
#   services             = "b"
#   resource_types       = "sco"

#   depends_on = [azurerm_storage_blob.this]
# }

data "azurerm_storage_account_sas" "this" {
  connection_string = azurerm_storage_account.this.primary_connection_string
  https_only        = true
  signed_version    = "2017-07-29"

  resource_types {
    service   = true
    container = false
    object    = false
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = "2018-03-21T00:00:00Z"
  expiry = "2025-03-21T00:00:00Z"

  permissions {
    read    = true
    write   = true
    delete  = false
    list    = false
    add     = true
    create  = true
    update  = false
    process = false
    tag     = false
    filter  = false
  }

  depends_on = [azurerm_storage_account.this]
}

resource "azurerm_storage_blob" "this" {
  name                   = local.static_index
  storage_account_name   = azurerm_storage_account.this.name
  storage_container_name = "$web" #azurerm_storage_container.this.name
  type                   = "Block"
  content_type           = "text/html"
  source                 = "${path.root}/${var.container.static_index}"

  depends_on = [local_file.this]
}

data "template_file" "html_template" {
  template = file("${path.root}/${var.container.static_index}.tpl")

  vars = {
    sas_token            = data.azurerm_storage_account_sas.this.sas
    storage_account_name = azurerm_storage_account.this.name
    container_name       = "$web" #azurerm_storage_container.container.name
    # file_name            = local.static_index
  }

  depends_on = [azurerm_storage_account.this, data.azurerm_storage_account_sas.this]
}

resource "local_file" "this" {
  content  = data.template_file.html_template.rendered
  filename = "${path.root}/${var.container.static_index}"
}
