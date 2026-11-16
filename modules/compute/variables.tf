variable "name_prefix" {
  type        = string
  description = "Prefix for resource names, for example ig-dev. The VM is named <prefix>-vm-01."

  validation {
    condition     = can(regex("^[a-z]([-a-z0-9]{0,22}[a-z0-9])?$", var.name_prefix))
    error_message = "name_prefix must be 1-24 characters: lowercase letters, digits and hyphens, starting with a letter and not ending with a hyphen."
  }
}

variable "zone" {
  type        = string
  description = "Zone of the VM, for example us-central1-a."

  validation {
    condition     = can(regex("^[a-z]+-[a-z]+[0-9]+-[a-z]$", var.zone))
    error_message = "zone must look like us-central1-a."
  }
}

variable "subnet_self_link" {
  type        = string
  description = "Self link of the subnet the VM attaches to."

  validation {
    condition     = can(regex("/subnetworks/", var.subnet_self_link))
    error_message = "subnet_self_link must be the self link of a subnet."
  }
}

variable "service_account_email" {
  type        = string
  description = "Email of the service account the VM runs as. Required, so the VM never falls back to the default compute account."

  validation {
    condition     = can(regex("^[^@\\s]+@[^@\\s]+$", var.service_account_email))
    error_message = "service_account_email must be an email address."
  }
}

variable "network_tags" {
  type        = list(string)
  description = "Network tags for the VM, for example the IAP SSH tag from the networking module."
  default     = []

  validation {
    condition     = alltrue([for t in var.network_tags : can(regex("^[a-z]([-a-z0-9]{0,61}[a-z0-9])?$", t))])
    error_message = "Each network tag must be 1-63 characters: lowercase letters, digits and hyphens, starting with a letter and not ending with a hyphen."
  }
}

variable "machine_type" {
  type        = string
  description = "Machine type. e2-micro is the free-tier machine."
  default     = "e2-micro"

  validation {
    condition     = contains(["e2-micro", "e2-small", "e2-medium"], var.machine_type)
    error_message = "machine_type must be e2-micro, e2-small or e2-medium."
  }
}

variable "boot_disk_size_gb" {
  type        = number
  description = "Boot disk size in GB. The free tier covers 30 GB-months of standard disk."
  default     = 10

  validation {
    condition     = var.boot_disk_size_gb >= 10 && var.boot_disk_size_gb <= 30 && floor(var.boot_disk_size_gb) == var.boot_disk_size_gb
    error_message = "boot_disk_size_gb must be a whole number from 10 to 30."
  }
}

variable "boot_image" {
  type        = string
  description = "Boot image as <project>/<family>."
  default     = "debian-cloud/debian-12"

  validation {
    condition     = can(regex("^[a-z0-9-]+/[a-z0-9-]+$", var.boot_image))
    error_message = "boot_image must look like debian-cloud/debian-12."
  }
}

variable "labels" {
  type        = map(string)
  description = "Labels applied to the VM."
  default     = {}
}
