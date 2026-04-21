include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }

terraform {
  source = "../../../../modules/dhcp-client"
}

inputs = {
  interface = "bridge"
}