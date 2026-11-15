variable "name_prefix" {
  type        = string
  description = "Prefix for resource names, for example ig-dev. Account IDs are <prefix>-<key>-sa."

  validation {
    condition     = can(regex("^[a-z]([-a-z0-9]{0,22}[a-z0-9])?$", var.name_prefix))
    error_message = "name_prefix must be 1-24 characters: lowercase letters, digits and hyphens, starting with a letter and not ending with a hyphen."
  }
}

variable "project_id" {
  type        = string
  description = "GCP project ID where project-level roles are granted."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "project_id must be 6-30 characters: lowercase letters, digits and hyphens, starting with a letter and not ending with a hyphen."
  }
}

variable "service_accounts" {
  type = map(object({
    description   = string
    project_roles = optional(list(string), [])
  }))
  description = "Service accounts to create, keyed by a short name. Each gets the account ID <name_prefix>-<key>-sa and only the project roles listed."

  validation {
    condition = alltrue([
      for key in keys(var.service_accounts) :
      can(regex("^[a-z]([a-z0-9-]*[a-z0-9])?$", key)) && length("${var.name_prefix}-${key}-sa") <= 30
    ])
    error_message = "Each key must be lowercase letters, digits and hyphens, starting with a letter, and the account ID <name_prefix>-<key>-sa must be at most 30 characters."
  }

  validation {
    condition = alltrue(flatten([
      for sa in values(var.service_accounts) : [
        for role in sa.project_roles :
        can(regex("^roles/", role)) && !can(regex("^roles/(owner|editor|viewer)$|^roles/iam\\.|^roles/resourcemanager\\.projectIamAdmin$", role))
      ]
    ]))
    error_message = "project_roles must be predefined roles (roles/...) and must not include basic roles (owner, editor, viewer) or IAM administration roles."
  }
}
