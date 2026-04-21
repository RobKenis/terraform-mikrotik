include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "provider" {
  path   = "./provider.hcl"
  expose = true
}

dependencies {
  paths = [find_in_parent_folders("router-rb1100ahx4")]
}

terraform {
  source = "../../modules/base"
}

inputs = {
  hostname = upper(split("-", basename(get_terragrunt_dir()))[1])
  timezone = "Europe/Brussels"

  vlans = {
    // TODO: Figure out how to set the interface of the VLAN to the bridge iso ether1
    Management = { name = "Management", vlan_id = 1000, interface = "ether1" }
    Trusted    = { name = "Trusted", vlan_id = 1100 }
    Guest      = { name = "Guest", vlan_id = 1200 }
  }

  ethernet_interfaces = {
    "ether1" = { comment = "Switch Uplink", bridge_port = false }
    "ether2" = { bridge_port = false }
  }
}