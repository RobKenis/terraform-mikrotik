include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }
include "dhcp" { path = find_in_parent_folders("network.hcl") }

terraform {
  source = "../../../../../modules/network"
}

inputs = {
  interface   = "Guest"
  address     = "192.168.96.1/24"
  network     = "192.168.96.0/24"
  gateway     = "192.168.96.1"
  dhcp_pool   = ["192.168.96.100-192.168.96.199"]
  lease_time  = "4h"
  dns_servers = ["9.9.9.9", "149.112.112.112"]
}