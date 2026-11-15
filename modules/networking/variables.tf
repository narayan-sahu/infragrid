variable "name_prefix" {
  type        = string
  description = "Prefix for resource names, for example ig-dev. Resources are named <prefix>-<component>."

  validation {
    condition     = can(regex("^[a-z]([-a-z0-9]{0,28}[a-z0-9])?$", var.name_prefix))
    error_message = "name_prefix must be 1-30 characters: lowercase letters, digits and hyphens, starting with a letter and not ending with a hyphen."
  }
}

variable "region" {
  type        = string
  description = "Region of the subnet."
}

variable "subnet_cidr" {
  type        = string
  description = "IPv4 range of the subnet, inside a private (RFC 1918) range."

  validation {
    condition     = can(cidrhost(var.subnet_cidr, 0)) && can(regex("^(10\\.|192\\.168\\.|172\\.(1[6-9]|2[0-9]|3[01])\\.)", var.subnet_cidr))
    error_message = "subnet_cidr must be a valid CIDR block inside a private (RFC 1918) range."
  }
}

variable "iap_ssh_tag" {
  type        = string
  description = "Network tag that grants IAP SSH access to an instance."
  default     = "ig-iap-ssh"

  validation {
    condition     = can(regex("^[a-z]([-a-z0-9]{0,61}[a-z0-9])?$", var.iap_ssh_tag))
    error_message = "iap_ssh_tag must be 1-63 characters: lowercase letters, digits and hyphens, starting with a letter and not ending with a hyphen."
  }
}
