resource "routeros_interface_bridge" "bridge" {
  name           = var.bridge_name
}

# Add interfaces as bridge members
resource "routeros_interface_bridge_port" "ethernet_ports" {
  for_each = {
    for k, v in var.ethernet_interfaces : k => v
    if v.bridge_port != false
  }

  bridge    = routeros_interface_bridge.bridge.name
  interface = each.key
  comment   = each.value.comment != null ? each.value.comment : ""
}