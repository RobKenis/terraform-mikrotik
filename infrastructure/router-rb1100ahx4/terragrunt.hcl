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
  }

  ethernet_interfaces = {
    "ether1" = { comment = "Telenet Uplink", bridge_port = false }
    "ether2" = {}
    "ether3" = {}
    # "ether4"  = {}
    "ether5"  = {}
    "ether6"  = {}
    "ether7"  = {}
    "ether8"  = {}
    "ether9"  = {}
    "ether10" = {}
    "ether11" = {}
    "ether12" = {}
    "ether13" = {}
  }
}