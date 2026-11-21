variable "project_id" {
  type        = string
  description = "GCP project ID of the run environment. Must start with infragrid-run-."

  validation {
    condition     = startswith(var.project_id, "infragrid-run-")
    error_message = "project_id must start with \"infragrid-run-\" in the run environment."
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
