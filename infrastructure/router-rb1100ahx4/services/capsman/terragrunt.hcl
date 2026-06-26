include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }

terraform {
  source = "../../../../modules/capsman"
}

inputs = {
  country            = "Belgium"
  capsman_interfaces = ["all"]
  upgrade_policy     = "suggest-same-version"

  channel_settings = {}

  wifi_networks = {}
}