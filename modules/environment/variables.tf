variable "environment" {
  type        = string
  description = "Environment name. Selects the per-environment settings."

  validation {
    condition     = contains(["dev", "test", "run"], var.environment)
    error_message = "environment must be one of: dev, test, run."
  }
}

variable "project_id" {
  type        = string
  description = "GCP project ID of this environment. Must start with infragrid-<environment>-."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "project_id must be 6-30 characters: lowercase letters, digits and hyphens, starting with a letter and not ending with a hyphen."
  }

  validation {
    condition     = startswith(var.project_id, "infragrid-${var.environment}-")
    error_message = "project_id must start with infragrid-<environment>- for the selected environment."
  }
}

variable "region" {
  type        = string
  description = "GCP region (free-tier US regions only)."
  default     = "us-central1"

  validation {
    condition     = contains(["us-west1", "us-central1", "us-east1"], var.region)
    error_message = "region must be a free-tier region: us-west1, us-central1 or us-east1."
  }
}

variable "zone" {
  type        = string
  description = "Zone of the VM. Must be inside the chosen region."
  default     = "us-central1-a"

  validation {
    condition     = startswith(var.zone, "${var.region}-")
    error_message = "zone must be inside the chosen region."
  }
}
