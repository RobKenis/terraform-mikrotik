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
    "5ghz-ax" = {
      skip_dfs_channels = "all"
      frequency         = ["5180", "5200", "5220", "5240"] # UNII-1: Channels 36, 40, 44, 48 (non-DFS)
      width             = "20/40mhz"
    }
    "2ghz-ax" = {
      frequency = ["2437"] # Channel 6
      width     = "20mhz"
    }
  }

  wifi_networks = {
    home-5ghz = {
      ssid    = "Rob en Lieze"
      band    = "5ghz-ac"
      vlan_id = "1100"
    }

    guest = {
      ssid             = "Rob en Lieze - Guest"
      band             = "2ghz-n"
      vlan_id          = "1200"
      client_isolation = true
    }
  }
}
