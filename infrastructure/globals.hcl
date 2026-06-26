locals {
  timezone = "Europe/Brussels"

  vlans = {
    Management = { name = "Management", vlan_id = 1000 }
    Trusted    = { name = "Trusted", vlan_id = 1100 }
    Guest      = { name = "Guest", vlan_id = 1200 }
  }

  all_vlans = keys(local.vlans)
}