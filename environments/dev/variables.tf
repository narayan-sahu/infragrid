variable "project_id" {
  type        = string
  description = "GCP project ID that this environment deploys into."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "project_id must be 6-30 characters: lowercase letters, digits and hyphens, starting with a letter and not ending with a hyphen."
  }

  validation {
    condition     = startswith(var.project_id, "infragrid-dev-")
    error_message = "project_id must start with \"infragrid-dev-\" in the dev environment."
  }
}

variable "region" {
  type        = string
  description = "GCP region for this environment (free-tier US regions only)."
  default     = "us-central1"

  validation {
    condition     = contains(["us-west1", "us-central1", "us-east1"], var.region)
    error_message = "region must be a free-tier region: us-west1, us-central1 or us-east1."
  }
}
