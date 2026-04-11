include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }

terraform {
  source = "../../../../modules/capsman"
}

inputs = {
  country            = "Belgium"
  capsman_interfaces = ["ether5"]
  upgrade_policy     = "suggest-same-version"
}
