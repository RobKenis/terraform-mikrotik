resource "routeros_ip_dhcp_client" "this" {
  interface         = var.interface
  comment           = "Allow upstream DHCP server to assign IP address"
  add_default_route = "yes"
  use_peer_dns      = true
  use_peer_ntp      = true
}
