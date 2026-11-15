resource "google_storage_bucket" "this" {
  name          = "${var.name_prefix}-${var.purpose}-${var.suffix}"
  location      = upper(var.region)
  storage_class = "STANDARD"
  force_destroy = var.force_destroy
  labels        = var.labels

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      days_since_noncurrent_time = var.noncurrent_version_retention_days
    }
    action {
      type = "Delete"
    }
  }
}

resource "google_storage_bucket_iam_member" "access" {
  for_each = var.object_access

  bucket = google_storage_bucket.this.name
  role   = each.value.role
  member = each.value.member
}
