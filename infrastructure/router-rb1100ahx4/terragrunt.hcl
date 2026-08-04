include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "provider" {
  path   = "./provider.hcl"
  expose = true
}

locals {
  globals = read_terragrunt_config(find_in_parent_folders("globals.hcl")).locals
}

terraform {
  source = "../../modules/base"
}

inputs = {
  hostname = upper(split("-", basename(get_terragrunt_dir()))[1])
  timezone = local.globals.timezone

  vlans = local.globals.vlans

  ethernet_interfaces = {
    "ether1"  = { comment = "Telenet Uplink", bridge_port = false }
    "ether2"  = { comment = "CSS326-24G-2S+RM", tagged = local.globals.all_vlans }
    "ether3"  = { untagged = "Management" }
    "ether4"  = {}
    "ether5"  = {}
    "ether6"  = { comment = "Office Downlink", tagged = local.globals.all_vlans }
    "ether7"  = { comment = "Living Room Downlink", tagged = local.globals.all_vlans }
    "ether8"  = {}
    "ether9"  = { comment = "Tower", untagged = "Trusted" }
    "ether10" = { comment = "Philips Hue Bridge", untagged = "Trusted" }
    "ether11" = {}
    "ether12" = {}
    "ether13" = {}
  }
}