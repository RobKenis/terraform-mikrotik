include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }

dependencies {
  paths = [find_in_parent_folders("router-rb1100ahx4")]
}

locals {
  mikrotik_globals = read_terragrunt_config(find_in_parent_folders("globals.hcl")).locals
}

terraform {
  source = "../../../../modules/firewall"
}

inputs = {
  interface_lists = {
    "WAN" = {
      comment    = "Interfacing going upstream"
      interfaces = ["ether1"]
    }
    LAN = {
      comment = "All Local Interfaces"
      interfaces = concat(
        ["bridge"],
        [for v in local.mikrotik_globals.vlans : v.name]
      )
    }
  }

  nat_rules = {
    "masquerade-wan" = {
      chain              = "srcnat"
      action             = "masquerade"
      out_interface_list = "WAN"
      order              = 100
    }
  }

  filter_rules = {
    # =========================================================================
    # GLOBAL RULES - Forward Chain
    # =========================================================================
    "fasttrack" = {
      chain            = "forward"
      action           = "fasttrack-connection"
      connection_state = "established,related"
      hw_offload       = true
      order            = 100
    }
    "accept-established-related-untracked-forward" = {
      chain            = "forward"
      action           = "accept"
      connection_state = "established,related,untracked"
      order            = 110
    }
    "asymmetric-routing-fix-trusted-to-mgmt" = {
      chain            = "forward"
      action           = "accept"
      connection_state = "invalid"
      in_interface     = local.mikrotik_globals.vlans.Trusted.name
      out_interface    = local.mikrotik_globals.vlans.Management.name
      order            = 120
    }
    "drop-invalid-forward" = {
      chain            = "forward"
      action           = "drop"
      connection_state = "invalid"
      order            = 130
    }

    # =========================================================================
    # GLOBAL RULES - Input Chain
    # =========================================================================
    "accept-capsman-loopback" = {
      chain       = "input"
      action      = "accept"
      dst_address = "127.0.0.1"
      order       = 200
    }
    "allow-LAN-icmp" = {
      chain             = "input"
      action            = "accept"
      protocol          = "icmp"
      in_interface_list = "LAN"
      order             = 210
    }
    "allow-LAN-dhcp-67" = {
      chain             = "input"
      action            = "accept"
      protocol          = "udp"
      dst_port          = "67"
      in_interface_list = "LAN"
      order             = 211
    }
    "allow-LAN-dhcp-68" = {
      chain             = "input"
      action            = "accept"
      protocol          = "udp"
      dst_port          = "68"
      in_interface_list = "LAN"
      order             = 212
    }
    "allow-LAN-dns-tcp" = {
      chain             = "input"
      action            = "accept"
      protocol          = "tcp"
      dst_port          = "53"
      in_interface_list = "LAN"
      order             = 213
    }
    "allow-LAN-dns-udp" = {
      chain             = "input"
      action            = "accept"
      protocol          = "udp"
      dst_port          = "53"
      in_interface_list = "LAN"
      order             = 214
    }
    "accept-router-established-related-untracked" = {
      chain            = "input"
      action           = "accept"
      connection_state = "established,related,untracked"
      order            = 220
    }

    # =========================================================================
    # ZONE-BASED RULES
    # =========================================================================
    "allow-MANAGEMENT-input" = {
      chain        = "input"
      action       = "accept"
      in_interface = local.mikrotik_globals.vlans.Management.name
      order        = 1100
    }
    "allow-MANAGEMENT-to-LAN" = {
      chain              = "forward"
      action             = "accept"
      in_interface       = local.mikrotik_globals.vlans.Management.name
      out_interface_list = "LAN"
      order              = 1110
    }

    "allow-MANAGEMENT-to-internet" = {
      chain              = "forward"
      action             = "accept"
      in_interface       = local.mikrotik_globals.vlans.Management.name
      out_interface_list = "WAN"
      order              = 1400
    }

    # ========================================================================
    # DEFAULT DENY
    # =========================================================================
    "drop-all-forward" = {
      chain        = "forward"
      action       = "drop"
      in_interface = "!${local.mikrotik_globals.vlans.Trusted.name}"
      order        = 9000
    }
    "drop-all-input" = {
      chain        = "input"
      action       = "drop"
      in_interface = "!${local.mikrotik_globals.vlans.Trusted.name}"
      order        = 9010
    }
  }
}
