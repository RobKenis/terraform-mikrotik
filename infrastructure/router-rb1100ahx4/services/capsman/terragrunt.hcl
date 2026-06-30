include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }

terraform {
  source = "../../../../modules/capsman"
}

inputs = {
  country            = "Belgium"
  capsman_interfaces = ["all"]
  upgrade_policy     = "suggest-same-version"

  channel_settings = {
    "5ghz-ac" = {
      skip_dfs_channels = "all"
      frequency         = ["5180", "5200", "5220", "5240"] # UNII-1: Channels 36, 40, 44, 48 (non-DFS)
      width             = "20/40mhz"
    }
    "2ghz-n" = {
      frequency = ["2437"] # Channel 6
      width     = "20mhz"
    }
  }

  wifi_networks = {
    home_5ghz = {
      ssid = "Lizzy Du Soleil - 5GHz"
      band = "5ghz-ac"
    }
    home_2ghz = {
      ssid = "Lizzy Du Soleil - 2GHz"
      band = "2ghz-n"
    }
  }
}