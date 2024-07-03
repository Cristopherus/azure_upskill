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

# resource "azurerm_function_app" "this" {
#   name                = "${var.project}-${var.environment}-function-app"
#   resource_group_name = azurerm_resource_group.resource_group.name
#   location            = var.location
#   app_service_plan_id = azurerm_app_service_plan.app_service_plan.id
#   app_settings = {
#     "WEBSITE_RUN_FROM_PACKAGE"       = "",
#     "FUNCTIONS_WORKER_RUNTIME"       = "node",
#     "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.application_insights.instrumentation_key,
#   }
#   os_type = "linux"
#   site_config {
#     linux_fx_version          = "node|14"
#     use_32_bit_worker_process = false
#   }
#   storage_account_name       = azurerm_storage_account.storage_account.name
#   storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
#   version                    = "~3"

#   lifecycle {
#     ignore_changes = [
#       app_settings["WEBSITE_RUN_FROM_PACKAGE"],
#     ]
#   }
# }
