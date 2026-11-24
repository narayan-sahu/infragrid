output "bucket_name" {
  description = "Name of the bucket."
  value       = google_storage_bucket.this.name
}

output "bucket_self_link" {
  description = "Self link of the bucket."
  value       = google_storage_bucket.this.self_link
}


output "force_destroy" {
  description = "Whether the bucket may be deleted while it contains objects."
  value       = google_storage_bucket.this.force_destroy
}

output "noncurrent_version_retention_days" {
  description = "Days after which non-current object versions are deleted."
  value       = one([for r in google_storage_bucket.this.lifecycle_rule : one(r.condition).days_since_noncurrent_time])
}
