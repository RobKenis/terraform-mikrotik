locals {
  # Flatten all interface VLAN assignments into a single list of
  # { vlan_name, iface, type } objects for easier grouping later.
  bridge_vlan_assignments = flatten([
    # Ethernet interfaces: tagged VLANs
    flatten([
      for iface_name, iface in var.ethernet_interfaces : [
        for vlan_name in(iface.tagged != null ? iface.tagged : []) : {
          vlan_name = vlan_name
          iface     = iface_name
          type      = "tagged"
        }
      ] if iface.tagged != null
    ]),
    # Ethernet interfaces: untagged (native) VLAN
    [
      for iface_name, iface in var.ethernet_interfaces : {
        vlan_name = iface.untagged
        iface     = iface_name
        type      = "untagged"
      } if iface.untagged != null && iface.untagged != ""
  ]])

  # Group assignments by VLAN name, producing tagged and untagged interface lists.
  vlan_assignments = { for vlan_name, _ in { for k, v in var.vlans : v.name => v } : vlan_name => {
    tagged = distinct([
      for assignment in local.bridge_vlan_assignments :
      assignment.iface if assignment.vlan_name == vlan_name && assignment.type == "tagged"
    ]),
    untagged = distinct([
      for assignment in local.bridge_vlan_assignments :
      assignment.iface if assignment.vlan_name == vlan_name && assignment.type == "untagged"
    ])
  } }

  # Build the final bridge VLAN entries. The bridge interface is always included
  # as a tagged member so traffic for each VLAN is accessible to the router CPU.
  final_bridge_vlans = {
    for vlan_name, vlan in { for k, v in var.vlans : v.name => v } : vlan_name => {
      vlan_ids = [vlan.vlan_id]
      tagged = distinct(concat(
        [var.bridge_name],
        lookup(local.vlan_assignments, vlan_name, { tagged = [] }).tagged
      ))
      untagged = lookup(local.vlan_assignments, vlan_name, { untagged = [] }).untagged
    }
  }
}

resource "routeros_interface_vlan" "vlans" {
  for_each = var.vlans

  interface = each.value.interface != null ? each.value.interface : var.bridge_name
  name      = each.value.name
  vlan_id   = each.value.vlan_id
}

resource "routeros_interface_bridge_vlan" "bridge_vlans" {
  for_each = local.final_bridge_vlans

  bridge   = routeros_interface_bridge.bridge.name
  comment  = each.key
  vlan_ids = each.value.vlan_ids

  tagged   = each.value.tagged
  untagged = each.value.untagged
}