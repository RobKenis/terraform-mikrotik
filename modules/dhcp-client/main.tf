resource "routeros_ip_dhcp_client" "this" {
  interface         = var.interface
  comment           = "Allow upstream DHCP server to assign IP address"
  add_default_route = "yes"
  use_peer_dns      = true
  use_peer_ntp      = true
}

resource "routeros_ip_firewall_nat" "allow_internet" {
  action        = "masquerade"
  chain         = "srcnat"
  out_interface = var.interface
  comment       = "Allow devices connected to ${var.interface} to access the internet via DHCP client"
}