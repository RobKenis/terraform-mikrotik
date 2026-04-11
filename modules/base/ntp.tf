resource "routeros_system_ntp_server" "server" {
  enabled = false
}

resource "routeros_system_ntp_client" "client" {
  enabled = true
  mode    = var.ntp_mode
  servers = var.ntp_servers
}