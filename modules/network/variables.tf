variable "interface" {
  description = "Name of the interface the DHCP server is bound to."
  type        = string

  validation {
    condition     = length(var.interface) > 0
    error_message = "The interface name must not be empty."
  }
}

# Network Configuration

variable "address" {
  description = "IP address in CIDR notation to assign to the interface (e.g., '192.168.1.1/24')."
  type        = string

  validation {
    condition     = can(cidrhost(var.address, 0))
    error_message = "The address must be in valid CIDR notation (e.g., '192.168.1.1/24')."
  }
}

variable "network" {
  description = "Network address in CIDR notation (e.g., '192.168.1.0/24')."
  type        = string

  validation {
    condition     = can(cidrhost(var.network, 0))
    error_message = "The network must be in valid CIDR notation (e.g., '192.168.1.0/24')."
  }
}

variable "gateway" {
  description = "Gateway IP address for the network. If not specified, defaults to the first usable IP in the network (the network address + 1)."
  type        = string
  default     = null

  validation {
    condition     = var.gateway == null || can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}$", var.gateway))
    error_message = "The gateway must be a valid IPv4 address (e.g., '192.168.1.1')."
  }
}

variable "dhcp_pool" {
  description = "List of IP ranges for the DHCP pool (e.g., ['192.168.1.100-192.168.1.200'])."
  type        = list(string)

  validation {
    condition     = length(var.dhcp_pool) > 0
    error_message = "At least one DHCP pool range must be specified."
  }

  validation {
    condition     = alltrue([for r in var.dhcp_pool : can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}-\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}$", r))])
    error_message = "Each pool range must be in the format 'START_IP-END_IP' (e.g., '192.168.1.100-192.168.1.200')."
  }
}

# DHCP Options

variable "dns_servers" {
  description = "List of DNS server IP addresses to provide to DHCP clients."
  type        = list(string)
  default     = []
}

variable "lease_time" {
  description = "Default DHCP lease time (e.g., '00:10:00' for 10 minutes, '1d 00:00:00' for 1 day). If not set, RouterOS default is used."
  type        = string
  default     = null
}
