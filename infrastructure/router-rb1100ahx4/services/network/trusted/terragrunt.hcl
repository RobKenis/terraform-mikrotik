include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }
include "dhcp" { path = find_in_parent_folders("network.hcl") }

terraform {
  source = "../../../../../modules/network"
}

inputs = {
  interface   = "Trusted"
  address     = "192.168.97.1/24"
  network     = "192.168.97.0/24"
  gateway     = "192.168.97.1"
  dhcp_pool   = ["192.168.97.100-192.168.97.199"]
  lease_time  = "4h"
  dns_servers = ["9.9.9.9", "149.112.112.112"]

  static_leases = {
    "192.168.97.5" = { name = "Living Room CAP", mac = "D0:EA:11:44:63:FA" }
  }
}