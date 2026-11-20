variable "project_id" {
  type        = string
  description = "GCP project ID of the dev environment. Must start with infragrid-dev-."

  validation {
    condition     = startswith(var.project_id, "infragrid-dev-")
    error_message = "project_id must start with \"infragrid-dev-\" in the dev environment."
  }
}

variable "region" {
  type        = string
  description = "GCP region. Validated by the environment module."
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "GCP zone. Validated by the environment module."
  default     = "us-central1-a"
}
