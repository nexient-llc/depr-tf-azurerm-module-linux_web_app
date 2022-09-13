# tf-azurerm-module-linux_web_app

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

This terraform module will provision an Azure Web app (linux), optional deployment stots, configurations and all its dependencies. This module would require the following resources to be already created
- Resource Group
- Storage Account
- Service Plan
- Container Registry (if application_stack='docker')

## Pre-Commit hooks
[.pre-commit-config.yaml](.pre-commit-config.yaml) file defines certain `pre-commit` hooks that are relevant to terraform, golang and common linting tasks. There are no custom hooks added.

`commitlint` hook enforces commit message in certain format. The commit contains the following structural elements, to communicate intent to the consumers of your commit messages:

- **fix**: a commit of the type `fix` patches a bug in your codebase (this correlates with PATCH in Semantic Versioning).
- **feat**: a commit of the type `feat` introduces a new feature to the codebase (this correlates with MINOR in Semantic Versioning).
- **BREAKING CHANGE**: a commit that has a footer `BREAKING CHANGE:`, or appends a `!` after the type/scope, introduces a breaking API change (correlating with MAJOR in Semantic Versioning). A BREAKING CHANGE can be part of commits of any type.
footers other than BREAKING CHANGE: <description> may be provided and follow a convention similar to git trailer format.
- **build**: a commit of the type `build` adds changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- **chore**: a commit of the type `chore` adds changes that don't modify src or test files
- **ci**: a commit of the type `ci` adds changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
- **docs**: a commit of the type `docs` adds documentation only changes
- **perf**: a commit of the type `perf` adds code change that improves performance
- **refactor**: a commit of the type `refactor` adds code change that neither fixes a bug nor adds a feature
- **revert**: a commit of the type `revert` reverts a previous commit
- **style**: a commit of the type `style` adds code changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **test**: a commit of the type `test` adds missing tests or correcting existing tests

Base configuration used for this project is [commitlint-config-conventional (based on the Angular convention)](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional#type-enum)

If you are a developer using vscode, [this](https://marketplace.visualstudio.com/items?itemName=joshbolduc.commitlint) plugin may be helpful.

`detect-secrets-hook` prevents new secrets from being introduced into the baseline. TODO: INSERT DOC LINK ABOUT HOOKS

In order for `pre-commit` hooks to work properly
- You need to have the pre-commit package manager installed. [Here](https://pre-commit.com/#install) are the installation instructions.
- `pre-commit` would install all the hooks when commit message is added by default except for `commitlint` hook. `commitlint` hook would need to be installed manually using the command below
```
pre-commit install --hook-type commit-msg
```

## To test the resource group module locally

1. For development/enhancements to this module locally, you'll need to install all of its components. This is controlled by the `configure` target in the project's [`Makefile`](./Makefile). Before you can run `configure`, familiarize yourself with the variables in the `Makefile` and ensure they're pointing to the right places.

```
make configure
```

This adds in several files and directories that are ignored by `git`. They expose many new Make targets.

2. The first target you care about is `env`. This is the common interface for setting up environment variables. The values of the environment variables will be used to authenticate with cloud provider from local development workstation.

`make configure` command will bring down `azure_env.sh` file on local workstation. Devloper would need to modify this file, replace the environment variable values with relevant values.

These environment variables are used by `terratest` integration suit.

Service principle used for authentication(value of ARM_CLIENT_ID) should have below privileges on resource group within the subscription.

```
"Microsoft.Resources/subscriptions/resourceGroups/write"
"Microsoft.Resources/subscriptions/resourceGroups/read"
"Microsoft.Resources/subscriptions/resourceGroups/delete"
```

Then run this make target to set the environment variables on developer workstation.

```
make env
```

3. The first target you care about is `check`.

**Pre-requisites**
Before running this target it is important to ensure that, developer has created files mentioned below on local workstation under root directory of git repository that contains code for primitives/segments. Note that these files are `azure` specific. If primitive/segment under development uses any other cloud provider than azure, this section may not be relevant.
- A file named `provider.tf` with contents below

```
provider "azurerm" {
  features {}
}
```
- A file named `terraform.tfvars` which contains key value pair of variables used.

Note that since these files are added in `gitignore` they would not be checked in into primitive/segment's git repo.

After creating these files, for running tests associated with the primitive/segment, run

```
make check
```

If `make check` target is successful, developer is good to commit the code to primitive/segment's git repo.

`make check` target
- runs `terraform commands` to `lint`,`validate` and `plan` terraform code.
- runs `conftests`. `conftests` make sure `policy` checks are successful.
- runs `terratest`. This is integration test suit.
- runs `opa` tests
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
# Terradocs
Below are the details that are generated by Terradocs plugin. It contains information about the module, inputs, outputs etc.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.0.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.18.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_web_app.web_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app) | resource |
| [azurerm_linux_web_app_slot.app_slot](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app_slot) | resource |
| [azurerm_application_insights.app_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_insights) | data source |
| [azurerm_container_registry.acr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/container_registry) | data source |
| [azurerm_service_plan.service_plan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/service_plan) | data source |
| [azurerm_storage_account.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | The resource group in which all the infrastructure would be created | <pre>object({<br>    name     = string<br>    location = string<br>  })</pre> | <pre>{<br>  "location": "eastus",<br>  "name": "deb-test-devops"<br>}</pre> | no |
| <a name="input_storage_account"></a> [storage\_account](#input\_storage\_account) | The storage account associated with the web-app | <pre>object({<br>    name    = string<br>    rg_name = string<br>  })</pre> | `null` | no |
| <a name="input_application_insights"></a> [application\_insights](#input\_application\_insights) | The Application Insights associated with the function app | <pre>object({<br>    name    = string<br>    rg_name = string<br>  })</pre> | `null` | no |
| <a name="input_service_plan"></a> [service\_plan](#input\_service\_plan) | The Service Plan associated with the web-app | <pre>object({<br>    name    = string<br>    rg_name = string<br>  })</pre> | n/a | yes |
| <a name="input_container_registry"></a> [container\_registry](#input\_container\_registry) | The Container Registry associated with the web-app. Required only when application\_stack = docker | <pre>object({<br>    name    = string<br>    rg_name = string<br>  })</pre> | <pre>{<br>  "name": "",<br>  "rg_name": ""<br>}</pre> | no |
| <a name="input_web_app_name"></a> [web\_app\_name](#input\_web\_app\_name) | Name of the linux web-app | `string` | n/a | yes |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Switch to enable linux web-app. Default is true | `bool` | `true` | no |
| <a name="input_https_only"></a> [https\_only](#input\_https\_only) | Switch for the flag https\_only. Default is false | `bool` | `false` | no |
| <a name="input_storage_mounts"></a> [storage\_mounts](#input\_storage\_mounts) | A map of storage mounts for the web-app. The account\_name and access\_key are optional and will be fetched from the storage\_account variable if not specified. The share\_name is either a blob or a fileshare in the storage\_account. The mount\_type can be either AzureFiles or AzureBlob | <pre>map(object({<br>    share_name   = string<br>    mount_type   = string<br>    mount_path   = string<br>    account_name = string<br>    access_key   = string<br>  }))</pre> | `{}` | no |
| <a name="input_application_stack"></a> [application\_stack](#input\_application\_stack) | One of these options - docker, dotnet, java, node, python, php, ruby | `string` | `"docker"` | no |
| <a name="input_docker_image_name"></a> [docker\_image\_name](#input\_docker\_image\_name) | The docker image name. Required only when application\_stack = docker. More information on configuring a custom container https://docs.microsoft.com/en-us/azure/app-service/configure-custom-container?pivots=container-linux | `string` | `"sample-app"` | no |
| <a name="input_docker_image_tag"></a> [docker\_image\_tag](#input\_docker\_image\_tag) | The docker image tag. Required only when application\_stack = docker | `string` | `"1001"` | no |
| <a name="input_dotnet_version"></a> [dotnet\_version](#input\_dotnet\_version) | Dotnet version for web-app runtime. Required only when application\_stack = dotnet. Must be 3.1 or 5.0 or 6.0 | `any` | `null` | no |
| <a name="input_java_version"></a> [java\_version](#input\_java\_version) | Java version for web-app runtime. Required only when application\_stack = java | `string` | `null` | no |
| <a name="input_java_server"></a> [java\_server](#input\_java\_server) | Java Server for web-app runtime. Required only when application\_stack = java. Use command 'az webapp list-runtimes --os-type=linux' for more details | `any` | `null` | no |
| <a name="input_java_server_version"></a> [java\_server\_version](#input\_java\_server\_version) | Java server version for web-app runtime. Required only when application\_stack = java. Use command 'az webapp list-runtimes --os-type=linux' for more details | `string` | `null` | no |
| <a name="input_node_version"></a> [node\_version](#input\_node\_version) | Node version for web-app runtime. Required only when application\_stack = node. Possible values are 12-lts, 14-lts, 16-lts | `string` | `null` | no |
| <a name="input_python_version"></a> [python\_version](#input\_python\_version) | Python version for web-app runtime. Required only when application\_stack = python. Possible values are 3.7, 3.8, 3.9. | `string` | `null` | no |
| <a name="input_ruby_version"></a> [ruby\_version](#input\_ruby\_version) | Ruby version for web-app runtime. Required only when application\_stack = ruby. Possible values are 2.6 or 2.7. | `string` | `null` | no |
| <a name="input_php_version"></a> [php\_version](#input\_php\_version) | Php version for the web-app runtime. Required only when application\_stack = php. Possible values are 7.4 or 8.0. | `string` | `null` | no |
| <a name="input_site_config"></a> [site\_config](#input\_site\_config) | All the site config mentioned in https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app#site_config except application\_stack | `any` | `{}` | no |
| <a name="input_application_settings"></a> [application\_settings](#input\_application\_settings) | The environment variables passed in to the web-app. Users can pass in any environment variable to be available to the web-app. System related app settings allowed to override are always\_on, http2\_enabled, minimum\_tls\_version, load\_balancing\_mode, scm\_minimum\_tls\_version, health\_check\_path, worker\_count, app\_command\_line, remote\_debugging\_version | `map(string)` | `{}` | no |
| <a name="input_connection_strings"></a> [connection\_strings](#input\_connection\_strings) | List of connection strings (name, type, value) | <pre>list(object({<br>    name  = string<br>    type  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_cors"></a> [cors](#input\_cors) | CORS block (allowed\_origins, support\_credentials) | <pre>object({<br>    allowed_origins     = list(string)<br>    support_credentials = bool<br>  })</pre> | `null` | no |
| <a name="input_detailed_error_messages"></a> [detailed\_error\_messages](#input\_detailed\_error\_messages) | Should detailed error messages be enabled? | `bool` | `false` | no |
| <a name="input_failed_request_tracing"></a> [failed\_request\_tracing](#input\_failed\_request\_tracing) | Should failed request tracing be enabled? | `bool` | `false` | no |
| <a name="input_http_logs_file_system"></a> [http\_logs\_file\_system](#input\_http\_logs\_file\_system) | HTTP Logs properties for type filesystem | <pre>object({<br>    retention_in_days = number<br>    retention_in_mb   = number<br>  })</pre> | `null` | no |
| <a name="input_http_logs_azure_blob_storage"></a> [http\_logs\_azure\_blob\_storage](#input\_http\_logs\_azure\_blob\_storage) | HTTP Logs properties type for Azure Blob Storage | <pre>object({<br>    level             = string<br>    retention_in_days = string<br>    sas_url           = string<br>  })</pre> | `null` | no |
| <a name="input_enable_system_managed_identity"></a> [enable\_system\_managed\_identity](#input\_enable\_system\_managed\_identity) | Should system\_managed\_identity be enabled? | `bool` | `false` | no |
| <a name="input_enable_application_insights"></a> [enable\_application\_insights](#input\_enable\_application\_insights) | Should app Insights be enabled for the web-app? If enabled, application\_insights is a required variable. | `bool` | `false` | no |
| <a name="input_deployment_slots"></a> [deployment\_slots](#input\_deployment\_slots) | List of the names of deployment\_slots for this app service | `list(string)` | `[]` | no |
| <a name="input_custom_tags"></a> [custom\_tags](#input\_custom\_tags) | Custom Tags for the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_web_app_id"></a> [web\_app\_id](#output\_web\_app\_id) | Id of the Linux Web App |
| <a name="output_web_app_name"></a> [web\_app\_name](#output\_web\_app\_name) | Name of the web-app |
| <a name="output_default_host_name"></a> [default\_host\_name](#output\_default\_host\_name) | Default host\_name of the Linux Web App |
| <a name="output_outbound_ip_address_list"></a> [outbound\_ip\_address\_list](#output\_outbound\_ip\_address\_list) | A list of Outbound IP address for the Linux Web App |
| <a name="output_possible_outbound_ip_address_list"></a> [possible\_outbound\_ip\_address\_list](#output\_possible\_outbound\_ip\_address\_list) | A list of all possible Outbound IP address for the Linux Web App |
| <a name="output_web_app_linux_slot_ids_map"></a> [web\_app\_linux\_slot\_ids\_map](#output\_web\_app\_linux\_slot\_ids\_map) | A map of deployment slot names to its ID |
| <a name="output_web_app_linux_slot_identities"></a> [web\_app\_linux\_slot\_identities](#output\_web\_app\_linux\_slot\_identities) | The list of identity blocks for deployment slots. This output is essential to add to the access policies of key-vault |
| <a name="output_connection_strings_list"></a> [connection\_strings\_list](#output\_connection\_strings\_list) | A list of connection string names |
| <a name="output_web_app_identity"></a> [web\_app\_identity](#output\_web\_app\_identity) | Identity block output of the Web App |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
