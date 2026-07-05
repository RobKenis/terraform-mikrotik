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


variable "filter_rules" {
  description = <<-EOT
    Map of firewall filter rules to create. Rules are ordered by the 'order'
    field, which determines their placement in the RouterOS filter chain. Lower
    numbers are evaluated first. The key is used as a human-readable identifier
    and is included in the auto-generated comment if no explicit comment is
    provided.

    Example:
    {
      "accept-established" = {
        chain            = "input"
        action           = "accept"
        connection_state = "established,related,untracked"
        order            = 100
      }
      "drop-invalid" = {
        chain            = "input"
        action           = "drop"
        connection_state = "invalid"
        order            = 200
      }
    }
  EOT
  type = map(object({
    chain              = string
    action             = string
    order              = number
    comment            = optional(string)
    connection_state   = optional(string)
    src_address        = optional(string)
    dst_address        = optional(string)
    src_address_list   = optional(string)
    dst_address_list   = optional(string)
    src_port           = optional(string)
    dst_port           = optional(string)
    protocol           = optional(string)
    in_interface       = optional(string)
    out_interface      = optional(string)
    in_interface_list  = optional(string)
    out_interface_list = optional(string)
    hw_offload         = optional(bool)
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.filter_rules : contains(["input", "forward", "output"], v.chain)
    ])
    error_message = "Filter rule chain must be one of: \"input\", \"forward\", \"output\"."
  }

  validation {
    condition = alltrue([
      for k, v in var.filter_rules : v.order >= 0
    ])
    error_message = "Filter rule order must be a non-negative number."
  }
}