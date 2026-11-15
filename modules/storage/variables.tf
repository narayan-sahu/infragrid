variable "name_prefix" {
  type        = string
  description = "Prefix for resource names, for example ig-dev."

  validation {
    condition     = can(regex("^[a-z]([-a-z0-9]{0,22}[a-z0-9])?$", var.name_prefix))
    error_message = "name_prefix must be 1-24 characters: lowercase letters, digits and hyphens, starting with a letter and not ending with a hyphen."
  }
}

variable "purpose" {
  type        = string
  description = "Short purpose of the bucket, for example artifacts. The bucket is named <name_prefix>-<purpose>-<suffix>."

  validation {
    condition     = can(regex("^[a-z]([a-z0-9-]{0,20}[a-z0-9])?$", var.purpose))
    error_message = "purpose must be 1-22 characters: lowercase letters, digits and hyphens, starting with a letter and not ending with a hyphen."
  }
}

variable "suffix" {
  type        = string
  description = "Random suffix that makes the globally unique bucket name hard to guess. Do not derive it from the project ID."

  validation {
    condition     = can(regex("^[a-z0-9]{4,8}$", var.suffix))
    error_message = "suffix must be 4-8 lowercase letters or digits."
  }

  validation {
    condition     = !startswith("${var.name_prefix}-${var.purpose}-${var.suffix}", "goog") && !strcontains("${var.name_prefix}-${var.purpose}-${var.suffix}", "google")
    error_message = "The bucket name must not start with \"goog\" or contain \"google\"."
  }
}

variable "region" {
  type        = string
  description = "Region of the bucket, for example us-central1."

  validation {
    condition     = can(regex("^[a-z]+-[a-z]+[0-9]+$", var.region))
    error_message = "region must look like us-central1."
  }
}

variable "labels" {
  type        = map(string)
  description = "Labels applied to the bucket."
  default     = {}
}

variable "force_destroy" {
  type        = bool
  description = "Allow Terraform to delete the bucket even if it contains objects. Keep false except in disposable environments."
  default     = false
}

variable "noncurrent_version_retention_days" {
  type        = number
  description = "Days after which non-current object versions are deleted."
  default     = 7

  validation {
    condition     = var.noncurrent_version_retention_days >= 1 && var.noncurrent_version_retention_days <= 365 && floor(var.noncurrent_version_retention_days) == var.noncurrent_version_retention_days
    error_message = "noncurrent_version_retention_days must be a whole number from 1 to 365."
  }
}

variable "object_access" {
  type = map(object({
    member = string
    role   = string
  }))
  description = "Bucket-level object access, keyed by a static label such as vm. Keys must be known at plan time, values may be computed."
  default     = {}

  validation {
    condition = alltrue([
      for a in values(var.object_access) :
      contains(["roles/storage.objectViewer", "roles/storage.objectCreator", "roles/storage.objectUser"], a.role)
    ])
    error_message = "role must be one of roles/storage.objectViewer, roles/storage.objectCreator or roles/storage.objectUser."
  }

  validation {
    condition = alltrue([
      for a in values(var.object_access) :
      can(regex("^(serviceAccount|user|group):\\S+$", a.member))
    ])
    error_message = "member must be a serviceAccount:, user: or group: principal. Public principals are not allowed."
  }
}
