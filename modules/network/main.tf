resource "routeros_ip_address" "this" {
  address   = var.address
  interface = var.interface
  network   = split("/", var.network)[0]
}

resource "routeros_ip_pool" "this" {
  name    = var.interface
  comment = "${var.interface} DHCP Pool"
  ranges  = var.dhcp_pool
}

resource "routeros_ip_dhcp_server_network" "this" {
  comment    = "${var.interface} DHCP Network"
  address    = var.network
  gateway    = cidrhost(var.network, 1)
  dns_server = var.dns_servers
}

resource "routeros_ip_dhcp_server" "this" {
  name         = var.interface
  comment      = "${var.interface} DHCP Server"
  address_pool = routeros_ip_pool.this.name
  interface    = var.interface
  lease_time   = var.lease_time
}
