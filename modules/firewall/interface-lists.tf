resource "routeros_interface_list" "this" {
  for_each = var.interface_lists

  name    = each.key
  comment = each.value.comment
}

locals {
  interface_list_members = merge([
    for list_name, list_config in var.interface_lists : {
      for interface in list_config.interfaces :
      "${list_name}/${interface}" => {
        list      = list_name
        interface = interface
      }
    }
  ]...)
}

resource "routeros_interface_list_member" "members" {
  for_each = local.interface_list_members

  interface = each.value.interface
  list      = each.value.list
}
