variable "country" {
  description = "Country name for WiFi regulatory compliance. Must match a value accepted by RouterOS (e.g. 'Romania', 'United States', 'Germany'). Set to null to leave unset."
  type        = string
  default     = null
}

variable "capsman_interfaces" {
  description = "List of interfaces where CAPsMAN will listen for CAP connections."
  type        = list(string)
  default     = ["all"]
}

variable "upgrade_policy" {
  description = "Firmware upgrade policy for managed CAP devices. Valid values: 'none', 'suggest-same-version', 'require-same-version'."
  type        = string
  default     = "none"

  validation {
    condition     = contains(["none", "suggest-same-version", "require-same-version"], var.upgrade_policy)
    error_message = "upgrade_policy must be one of: none, suggest-same-version, require-same-version."
  }
}