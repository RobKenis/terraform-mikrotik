# Interface List Configuration

variable "interface_lists" {
  # Key is the name of the List
  type = map(object({
    comment    = optional(string, "")
    interfaces = list(string)
  }))
  default = {}
}

# NAT Rules

variable "nat_rules" {
  description = <<-EOT
    Map of NAT rules to create. Rules are ordered by the 'order' field, which
    determines their placement in the RouterOS NAT chain. Lower numbers are
    evaluated first. The key is used as a human-readable identifier and is
    included in the auto-generated comment if no explicit comment is provided.

    Example:
    {
      "masquerade-wan" = {
        chain              = "srcnat"
        action             = "masquerade"
        out_interface_list = "WAN"
        order              = 100
      }
    }
  EOT
  type = map(object({
    chain              = string
    action             = string
    order              = number
    out_interface_list = optional(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.nat_rules : contains(["srcnat", "dstnat"], v.chain)
    ])
    error_message = "NAT rule chain must be one of: \"srcnat\", \"dstnat\"."
  }

  validation {
    condition = alltrue([
      for k, v in var.nat_rules : v.order >= 0
    ])
    error_message = "NAT rule order must be a non-negative number."
  }
}