resource "routeros_interface_bridge" "bridge" {
  name           = var.bridge_name
  vlan_filtering = true
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

  # Set the PVID to the untagged VLAN ID so ingress untagged frames are
  # assigned to the correct VLAN. Defaults to VLAN 1 if no untagged VLAN is set.
  pvid = (each.value.untagged != null && each.value.untagged != "") ? (
    [for k, v in var.vlans : v.vlan_id if v.name == each.value.untagged][0]
  ) : 1
}