include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }
include "dhcp" { path = find_in_parent_folders("network.hcl") }

terraform {
  source = "../../../../../modules/network"
}

inputs = {
  interface   = "Management"
  address     = "10.0.0.1/24"
  network     = "10.0.0.0/24"
  gateway     = "10.0.0.1"
  dhcp_pool   = ["10.0.0.195-10.0.0.199"]
  lease_time  = "4h"
  dns_servers = ["9.9.9.9", "149.112.112.112"]

  static_leases = {
    # Network - Switches
    "10.0.0.2" = { name = "CSS326", mac = "04:F4:1C:FB:6E:6D" }
    "10.0.0.3" = { name = "hAP AC Lite", mac = "F4:1E:57:7F:CD:1C" }

    # Network - Access Points
    # "10.0.0.5" = { name = "Living Room CAP", mac = "D0:EA:11:44:63:FA" }
    "10.0.0.6" = { name = "TP Link Omada AC1350", mac = "28:87:BA:43:AB:26" }

    # Servers
    "10.0.0.100" = { name = "Dumbledork", mac = "B8:27:EB:EB:D2:A8" }
  }
}