resource "routeros_interface_ethernet" "ethernet" {
  for_each = var.ethernet_interfaces

  factory_name = each.key
  name         = each.key
  comment      = each.value.comment
}