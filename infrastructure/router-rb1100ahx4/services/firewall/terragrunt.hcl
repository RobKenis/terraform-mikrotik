include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }

terraform {
  source = "../../../../modules/firewall"
}

inputs = {
  interface_lists = {
    "WAN" = {
      comment    = "Interfacing going upstream"
      interfaces = ["ether1"]
    }
  }

  nat_rules = {
    "masquerade-wan" = {
      chain              = "srcnat"
      action             = "masquerade"
      out_interface_list = "WAN"
      order              = 100
    }
  }
}
