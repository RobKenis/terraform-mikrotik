# System Settings
variable "hostname" {
  type        = string
  description = "The hostname (system identity) to set on the Mikrotik device."
}

variable "timezone" {
  type        = string
  default     = "UTC"
  description = "The timezone to set on the device (e.g., 'UTC', 'America/New_York', 'Europe/London')."

  validation {
    condition     = can(regex("^[A-Z][a-zA-Z0-9_]+(/[A-Z][a-zA-Z0-9_-]+)*$", var.timezone)) || var.timezone == "UTC"
    error_message = "Timezone must be a valid tz database name (e.g., 'UTC', 'America/New_York')."
  }
}

variable "ntp_servers" {
  type        = list(string)
  default     = ["time.cloudflare.com"]
  description = "List of NTP server addresses for time synchronization."
}

variable "ntp_mode" {
  type        = string
  default     = "unicast"
  description = "NTP client mode. Valid values: unicast, broadcast, multicast, manycast."

  validation {
    condition     = contains(["unicast", "broadcast", "multicast", "manycast"], var.ntp_mode)
    error_message = "NTP mode must be one of: unicast, broadcast, multicast, manycast."
  }
}

# Bride Settings

variable "bridge_name" {
  type        = string
  default     = "bridge"
  description = "Name of the main bridge interface."
}

# Interface Configuration
variable "ethernet_interfaces" {
  type = map(object({
    comment     = optional(string, "")
    bridge_port = optional(bool, true)
    # Trunk ports
    tagged = optional(list(string))
    # Access ports
    untagged = optional(string)
  }))
  default     = {}
  description = "Map of ethernet interfaces to configure. Keys are interface names (e.g., 'ether1'). Supports bridge membership and VLAN tagging."
}

# VLAN Configuration

variable "vlans" {
  type = map(object({
    name    = string
    vlan_id = number
    mtu     = optional(number, 1500)
  }))
  default     = {}
  description = "Map of VLANs to configure. Each entry requires a human-readable name and a VLAN ID."

  validation {
    condition = alltrue([
      for k, v in var.vlans : v.vlan_id >= 1 && v.vlan_id <= 4094
    ])
    error_message = "VLAN IDs must be between 1 and 4094."
  }
}
