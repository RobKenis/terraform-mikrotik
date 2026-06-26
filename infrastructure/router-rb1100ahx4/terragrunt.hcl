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
    "ether4"  = { comment = "hAP AC Lite", tagged = local.globals.all_vlans }
    "ether5"  = {}
    "ether6"  = {}
    "ether7"  = {}
    "ether8"  = { comment = "Living Room CAP", tagged = local.globals.all_vlans }
    "ether9"  = {}
    "ether10" = {}
    "ether11" = {}
    "ether12" = {}
    "ether13" = {}
  }
}