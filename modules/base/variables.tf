# Settings
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
