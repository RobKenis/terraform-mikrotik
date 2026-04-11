locals {
  nat_rules_ordered = [
    for k, v in var.nat_rules : merge(v, {
      key      = k
      sort_key = format("%04d-%s", v.order, k)
    })
  ]

  nat_rules_map = {
    for rule in local.nat_rules_ordered :
    rule.sort_key => rule
  }
}

resource "routeros_ip_firewall_nat" "this" {
  for_each = local.nat_rules_map

  comment = each.value.key
  chain   = each.value.chain
  action  = each.value.action

  out_interface_list = each.value.out_interface_list

  depends_on = [routeros_interface_list.this]
}