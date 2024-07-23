resource "azurerm_storage_account" "this" {
  name                     = "${var.function_name}function"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind

  tags = var.tags
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
  version                    = "~3"

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = azurerm_storage_blob.trigger.url

    FUNCTIONS_WORKER_RUNTIME = "python"
    STORAGE_ACCOUNT_NAME     = azurerm_storage_account.this.name
    CONTAINER_NAME           = azurerm_storage_container.this.name
  }

  # site_config {
  #   app_command_line = "python function_app.py"
  # }

  # storage_account {
  #   storage_container_name = azurerm_storage_container.uploads.name
  #   name                   = "function_app"
  #   type                   = "zip"
  #   source_path            = "function_app.zip"
  # }
}


resource "azurerm_storage_container" "this" {
  name                  = var.function_name
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}


resource "azurerm_storage_blob" "trigger" {
  name                   = "trigger-function.zip"
  storage_account_name   = azurerm_storage_account.this.name
  storage_container_name = azurerm_storage_container.this.name
  type                   = "Block"
  source                 = "function_app.zip"

  depends_on = [data.archive_file.function, azurerm_storage_container.this]
}

data "archive_file" "function" {
  type        = "zip"
  source_dir  = "${path.root}/function_app"
  output_path = "${path.root}/function_app.zip"
}

# resource "azurerm_eventgrid_event_subscription" "this" {
#   name  = "${var.function_name}-subscription"
#   scope = azurerm_storage_account.this.id

#   # eventhub_id = azurerm_eventhub_namespace.example.id

#   retry_policy {
#     event_time_to_live    = "1440"
#     max_delivery_attempts = "30"
#   }

#   included_event_types = ["Microsoft.Storage.BlobCreated"]

#   webhook_endpoint {
#     url = azurerm_function_app.this.default_hostname
#   }
# }
