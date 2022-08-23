locals {
  is_docker = var.application_stack == "docker" ? true : false

  default_tags = {
    "provisioner" : "Terraform"
  }
  tags = merge(local.default_tags, var.custom_tags)

  dotnet_version      = var.application_stack == "dotnet" ? var.dotnet_version : null
  java_version        = var.application_stack == "java" ? var.java_version : null
  java_server         = var.application_stack == "java" ? var.java_server : null
  java_server_version = var.application_stack == "java" ? var.java_server_version : null
  node_version        = var.application_stack == "node" ? var.node_version : null
  python_version      = var.application_stack == "python" ? var.python_version : null
  php_version         = var.application_stack == "php" ? var.php_version : null
  ruby_version        = var.application_stack == "ruby" ? var.ruby_version : null
  docker_image        = local.is_docker ? "${data.azurerm_container_registry.acr[0].login_server}/${var.docker_image_name}" : null


  cors = var.cors != null ? toset([var.cors]) : toset([])

  is_http_logs = (var.http_logs_file_system != null || var.http_logs_azure_blob_storage != null) ? true : false

  docker_app_settings = local.is_docker ? {
    DOCKER_REGISTRY_SERVER_PASSWORD = data.azurerm_container_registry.acr[0].admin_password
    DOCKER_REGISTRY_SERVER_USERNAME = data.azurerm_container_registry.acr[0].admin_username
    DOCKER_REGISTRY_SERVER_URL      = "https://${data.azurerm_container_registry.acr[0].login_server}"
  } : {}
  app_insights_app_settings = var.enable_application_insights ? {
    APPINSIGHTS_INSTRUMENTATIONKEY             = data.azurerm_application_insights.app_insights[0].instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING      = data.azurerm_application_insights.app_insights[0].connection_string
    ApplicationInsightsAgent_EXTENSION_VERSION = "~2"
  } : {}
}