variable "project_id" {
  type        = string
  description = "GCP project ID of the test environment. Must start with infragrid-test-."

  validation {
    condition     = startswith(var.project_id, "infragrid-test-")
    error_message = "project_id must start with \"infragrid-test-\" in the test environment."
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
