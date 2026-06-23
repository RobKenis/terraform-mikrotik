include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "provider" {
  path   = "./provider.hcl"
  expose = true
}

terraform {
  source = "../../modules/base"
}

inputs = {
  hostname = upper(split("-", basename(get_terragrunt_dir()))[1])
  timezone = "Europe/Brussels"

  vlans = {
    Management = { name = "Management", vlan_id = 1000 }
    Trusted    = { name = "Trusted", vlan_id = 1100 }
    Guest      = { name = "Guest", vlan_id = 1200 }
  }

  ethernet_interfaces = {
    "ether1" = { comment = "Router Uplink", tagged = ["Management", "Trusted", "Guest"] }
    "ether2" = {}
    "ether3" = { untagged = "Management" }
    "ether4" = { untagged = "Trusted" }
    "ether5" = { untagged = "Guest" }
  }
}