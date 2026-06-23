output "wifi_password" {
  value       = { for k, v in random_pet.wifi_passphrase : k => v.id }
  description = "The generated wifi password for each network"
}
