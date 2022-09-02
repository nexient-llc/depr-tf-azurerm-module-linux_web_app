# Copyright 2022 Nexient LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

output "web_app_id" {
  description = "Id of the Linux Web App"
  value       = azurerm_linux_web_app.web_app.id
}

output "web_app_name" {
  description = "Name of the web-app"
  value       = azurerm_linux_web_app.web_app.name
}

output "default_host_name" {
  description = "Default host_name of the Linux Web App"
  value       = azurerm_linux_web_app.web_app.default_hostname
}

output "outbound_ip_address_list" {
  description = "A list of Outbound IP address for the Linux Web App"
  value       = azurerm_linux_web_app.web_app.outbound_ip_address_list
}

output "possible_outbound_ip_address_list" {
  description = "A list of all possible Outbound IP address for the Linux Web App"
  value       = azurerm_linux_web_app.web_app.possible_outbound_ip_address_list
}

output "web_app_linux_slot_ids_map" {
  description = "A map of deployment slot names to its ID"
  value       = { for key, value in azurerm_linux_web_app_slot.app_slot : key => value.id }
}

output "web_app_linux_slot_identities" {
  description = "The list of identity blocks for deployment slots. This output is essential to add to the access policies of key-vault"
  value       = { for key, slot in azurerm_linux_web_app_slot.app_slot : key => slot.identity[0] }
}

output "connection_strings_list" {
  description = "A list of connection string names"
  value       = [for conn in azurerm_linux_web_app.web_app.connection_string : conn.value]

}

output "web_app_identity" {
  value       = try(azurerm_linux_web_app.web_app.identity[0], null)
  description = "Identity block output of the Web App"
}
