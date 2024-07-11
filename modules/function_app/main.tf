resource "azurerm_storage_account" "this" {
  name                     = "${var.function_name}function"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind

  tags = var.tags
}

resource "azurerm_application_insights" "this" {
  name                = "${var.function_name}-application-insights"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = var.application_type
}

resource "azurerm_app_service_plan" "this" {
  name                = "${var.function_name}-app-service-plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  kind                = "FunctionApp"
  reserved            = true # TODO fix this hardcoded values
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "this" {
  name                       = "${var.function_name}-app"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = azurerm_app_service_plan.this.id
  storage_account_name       = azurerm_storage_account.this.name
  storage_account_access_key = azurerm_storage_account.this.primary_access_key
  site_config {
    dotnet_framework_version = "v6.0"
  }
}


resource "azurerm_storage_container" "this" {
  name                  = var.function_name
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}


resource "azurerm_storage_blob" "storage_blob_function" {
  name                   = "app.zip"
  storage_account_name   = azurerm_storage_account.this.name
  storage_container_name = azurerm_storage_container.this.name
  type                   = "Block"
  # content_md5            = data.archive_file.function.output_md5
  source = "${path.module}/app.zip"
}
