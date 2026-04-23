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
    "ether1"  = { comment = "Telenet Uplink", bridge_port = false }
    "ether2"  = { comment = "CSS326-24G-2S+RM", tagged = ["Management", "Trusted", "Guest"] }
    "ether3"  = { untagged = "Management" }
    "ether4"  = {}
    "ether5"  = {}
    "ether6"  = {}
    "ether7"  = {}
    "ether8"  = { comment = "Living Room CAP", untagged = "Management", tagged = ["Trusted", "Guest"] }
    "ether9"  = {}
    "ether10" = {}
    "ether11" = {}
    "ether12" = {}
    "ether13" = {}
  }
}