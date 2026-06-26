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
    "ether1" = { comment = "Router Uplink", tagged = local.globals.all_vlans }
    "ether2" = {}
    "ether3" = { untagged = "Management" }
    "ether4" = { untagged = "Trusted" }
    "ether5" = { untagged = "Guest" }
  }
}