resource "routeros_wifi_capsman" "settings" {
  enabled        = true
  interfaces     = var.capsman_interfaces
  upgrade_policy = var.upgrade_policy
}
