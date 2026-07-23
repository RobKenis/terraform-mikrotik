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
    # Network - Access Points
    "192.168.97.5" = { name = "Living Room CAP", mac = "D0:EA:11:44:63:FA" }

    # IoT
    "192.168.97.50" = { name = "Sunny Boy", mac = "a0:c9:a0:11:b7:2e" }
    "192.168.97.51" = { name = "P1 Meter", mac = "5c:2f:af:3e:8e:5a" }
    "192.168.97.52" = { name = "iRobot", mac = "50:14:79:87:6a:ff" }
  }
}