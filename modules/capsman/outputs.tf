output "wifi_passphrases" {
  description = "Map of WiFi network keys to their passphrases (provided or auto-generated)."
  value       = local.wifi_passphrases
  sensitive   = true
}

output "configured_ssids" {
  description = "List of all configured WiFi SSIDs."
  value       = [for k, v in var.wifi_networks : v.ssid]
}