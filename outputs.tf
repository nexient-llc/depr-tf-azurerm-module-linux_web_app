output "web_app_id" {
  description = "Id of the Linux Web App"
  value       = azurerm_linux_web_app.web_app.id
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

output "connection_strings_list" {
  description = "A list of connection string names"
  value       = [for conn in azurerm_linux_web_app.web_app.connection_string : conn.value]

}

output "web_app_identity" {
  value       = try(azurerm_linux_web_app.web_app.identity[0], null)
  description = "Identity block output of the Web App"
}