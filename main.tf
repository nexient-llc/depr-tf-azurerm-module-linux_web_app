data "azurerm_container_registry" "acr" {
  # Required when application_stack=docker
  count = local.is_docker ? 1 : 0

  name                = var.container_registry.name
  resource_group_name = var.container_registry.rg_name
}

data "azurerm_storage_account" "storage_account" {
  name                = var.storage_account.name
  resource_group_name = var.storage_account.rg_name
}

data "azurerm_application_insights" "app_insights" {
  count               = var.enable_application_insights ? 1 : 0
  name                = var.application_insights.name
  resource_group_name = var.application_insights.rg_name
}

data "azurerm_service_plan" "service_plan" {
  name                = var.service_plan.name
  resource_group_name = var.service_plan.rg_name
}

resource "azurerm_linux_web_app" "web_app" {
  name                = var.web_app_name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  service_plan_id     = data.azurerm_service_plan.service_plan.id

  app_settings = merge(local.docker_app_settings, local.app_insights_app_settings, var.application_settings)
  enabled      = var.enabled
  https_only   = var.https_only

  dynamic "connection_string" {
    for_each = var.connection_strings
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  site_config {
    always_on = lookup(var.site_config, "always_on", false)
    #api_management_config_id = lookup(var.site_config, "api_management_config_id", null)
    app_command_line = lookup(var.site_config, "app_command_line", null)
    #remote_debugging         = lookup(var.site_config, "remote_debugging", false)
    remote_debugging_version = lookup(var.site_config, "remote_debugging_version", null)
    http2_enabled            = lookup(var.site_config, "http2enabled", true)
    minimum_tls_version      = lookup(var.site_config, "minimum_tls_version", 1.2)
    load_balancing_mode      = lookup(var.site_config, "load_balancing_mode", "LeastRequests")
    scm_minimum_tls_version  = lookup(var.site_config, "scm_minimum_tls_version", 1.2)
    health_check_path        = lookup(var.site_config, "health_check_path", null)
    worker_count             = lookup(var.site_config, "worker_count", 1)


    application_stack {
      dotnet_version      = local.dotnet_version
      java_version        = local.java_version
      java_server         = local.java_server
      java_server_version = local.java_server_version
      node_version        = local.node_version
      python_version      = local.python_version
      php_version         = local.php_version
      ruby_version        = local.ruby_version
      docker_image        = local.docker_image
      docker_image_tag    = var.docker_image_tag
    }

    dynamic "cors" {
      for_each = local.cors
      content {
        allowed_origins     = cors.value.allowed_origins
        support_credentials = cors.value.support_credentials
      }
    }
  }

  logs {
    detailed_error_messages = var.detailed_error_messages
    failed_request_tracing  = var.failed_request_tracing

    dynamic "http_logs" {
      for_each = local.is_http_logs ? [1] : []
      content {
        dynamic "file_system" {
          for_each = var.http_logs_file_system != null ? [var.http_logs_file_system] : []
          content {
            retention_in_days = file_system.value.retention_in_days
            retention_in_mb   = file_system.value.retention_in_mb
          }
        }
        dynamic "azure_blob_storage" {
          for_each = var.http_logs_azure_blob_storage != null ? [var.http_logs_azure_blob_storage] : []
          content {
            #level = azure_blob_storage.value.level
            retention_in_days = azure_blob_storage.value.retention_in_days
            sas_url           = azure_blob_storage.value.sas_url
          }
        }
      }
    }
  }

  dynamic "storage_account" {
    for_each = var.storage_mounts
    content {
      name         = storage_account.key
      type         = storage_account.value.mount_type
      mount_path   = storage_account.value.mount_path
      # Storage account can be passed in from vars file or use the implicit storage account of the module
      account_name = coalesce(storage_account.value.account_name, "notset") == "notset" ? data.azurerm_storage_account.storage_account.name : storage_account.value.account_name
      access_key   = coalesce(storage_account.value.access_key, "notset") == "notset" ? data.azurerm_storage_account.storage_account.primary_access_key : storage_account.value.access_key
      share_name   = storage_account.value.share_name
    }
  }

  dynamic "identity" {
    for_each = var.enable_system_managed_identity ? toset(["SystemAssigned"]) : toset([])
    content {
      type         = identity.value
      identity_ids = []
    }
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [
      site_config[0].application_stack[0].docker_image,
      site_config[0].application_stack[0].docker_image_tag

    ]
  }
}

resource "azurerm_linux_web_app_slot" "app_slot" {

  for_each = toset(var.deployment_slots)

  name           = each.value
  app_service_id = azurerm_linux_web_app.web_app.id

  app_settings = merge(local.docker_app_settings, local.app_insights_app_settings, var.application_settings)
  enabled      = var.enabled
  https_only   = var.https_only

  dynamic "connection_string" {
    for_each = var.connection_strings
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }
  site_config {
    always_on                = lookup(var.site_config, "always_on", false)
    app_command_line         = lookup(var.site_config, "app_command_line", null)
    remote_debugging_version = lookup(var.site_config, "remote_debugging_version", null)
    http2_enabled            = lookup(var.site_config, "http2enabled", true)
    minimum_tls_version      = lookup(var.site_config, "minimum_tls_version", 1.2)
    load_balancing_mode      = lookup(var.site_config, "load_balancing_mode", "LeastRequests")
    scm_minimum_tls_version  = lookup(var.site_config, "scm_minimum_tls_version", 1.2)
    health_check_path        = lookup(var.site_config, "health_check_path", null)
    worker_count             = lookup(var.site_config, "worker_count", 1)


    application_stack {
      dotnet_version      = local.dotnet_version
      java_version        = local.java_version
      java_server         = local.java_server
      java_server_version = local.java_server_version
      node_version        = local.node_version
      python_version      = local.python_version
      php_version         = local.php_version
      ruby_version        = local.ruby_version
      docker_image        = local.docker_image
      docker_image_tag    = var.docker_image_tag
    }

    dynamic "cors" {
      for_each = local.cors
      content {
        allowed_origins     = cors.value.allowed_origins
        support_credentials = cors.value.support_credentials
      }
    }
  }

  logs {
    detailed_error_messages = var.detailed_error_messages
    failed_request_tracing  = var.failed_request_tracing

    dynamic "http_logs" {
      for_each = local.is_http_logs ? [1] : []
      content {
        dynamic "file_system" {
          for_each = var.http_logs_file_system != null ? [var.http_logs_file_system] : []
          content {
            retention_in_days = file_system.value.retention_in_days
            retention_in_mb   = file_system.value.retention_in_mb
          }
        }
        dynamic "azure_blob_storage" {
          for_each = var.http_logs_azure_blob_storage != null ? [var.http_logs_azure_blob_storage] : []
          content {
            #level = azure_blob_storage.value.level
            retention_in_days = azure_blob_storage.value.retention_in_days
            sas_url           = azure_blob_storage.value.sas_url
          }
        }
      }
    }
  }

  dynamic "storage_account" {
    for_each = var.storage_mounts
    content {
      name         = storage_account.key
      type         = storage_account.value.mount_type
      mount_path   = storage_account.value.mount_path
      # Storage account can be passed in from vars file or use the implicit storage account of the module
      account_name = coalesce(storage_account.value.account_name, "notset") == "notset" ? data.azurerm_storage_account.storage_account.name : storage_account.value.account_name
      access_key   = coalesce(storage_account.value.access_key, "notset") == "notset" ? data.azurerm_storage_account.storage_account.primary_access_key : storage_account.value.access_key
      share_name   = storage_account.value.share_name
    }
  }

  dynamic "identity" {
    for_each = var.enable_system_managed_identity ? toset(["SystemAssigned"]) : toset([])
    content {
      type         = identity.value
      identity_ids = []
    }
  }

  tags = local.tags
}