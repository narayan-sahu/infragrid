variable "region" {
  type        = string
  description = "GCP region for this environment (free-tier US regions only)."
  default     = "us-central1"

  validation {
    condition     = contains(["us-west1", "us-central1", "us-east1"], var.region)
    error_message = "region must be a free-tier region: us-west1, us-central1 or us-east1."
  }
}

variable "environment" {
  type        = string
  description = "Environment name used in resource names and labels."
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "run"], var.environment)
    error_message = "environment must be one of: dev, test, run."
  }
}