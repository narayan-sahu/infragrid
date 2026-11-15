mock_provider "google" {}

variables {
  name_prefix = "ig-dev"
  purpose     = "artifacts"
  suffix      = "x7k2"
  region      = "us-central1"
}

run "bucket_has_secure_defaults" {
  command = plan

  assert {
    condition     = google_storage_bucket.this.name == "ig-dev-artifacts-x7k2"
    error_message = "The bucket must be named <prefix>-<purpose>-<suffix>."
  }

  assert {
    condition     = google_storage_bucket.this.location == "US-CENTRAL1" && google_storage_bucket.this.storage_class == "STANDARD"
    error_message = "The bucket must be a Standard-class bucket in the requested region."
  }

  assert {
    condition     = google_storage_bucket.this.uniform_bucket_level_access == true
    error_message = "Uniform bucket-level access must be enabled."
  }

  assert {
    condition     = google_storage_bucket.this.public_access_prevention == "enforced"
    error_message = "Public access prevention must be enforced."
  }

  assert {
    condition     = google_storage_bucket.this.force_destroy == false
    error_message = "force_destroy must default to false."
  }

  assert {
    condition     = one(google_storage_bucket.this.versioning).enabled == true
    error_message = "Versioning must be enabled."
  }
}

run "old_versions_expire" {
  command = plan

  assert {
    condition = length(google_storage_bucket.this.lifecycle_rule) == 1 && alltrue([
      for r in google_storage_bucket.this.lifecycle_rule :
      one(r.condition).days_since_noncurrent_time == 7 && one(r.action).type == "Delete"
    ])
    error_message = "Non-current versions must be deleted after 7 days by default."
  }
}

run "no_access_granted_by_default" {
  command = plan

  assert {
    condition     = length(google_storage_bucket_iam_member.access) == 0
    error_message = "No bucket access may be granted unless requested."
  }
}

run "grants_only_requested_access" {
  command = plan

  variables {
    object_access = {
      vm = {
        member = "serviceAccount:ig-dev-vm-sa@infragrid-dev-test1.iam.gserviceaccount.com"
        role   = "roles/storage.objectUser"
      }
    }
  }

  assert {
    condition     = length(google_storage_bucket_iam_member.access) == 1
    error_message = "Exactly one access grant must be created."
  }

  assert {
    condition     = google_storage_bucket_iam_member.access["vm"].role == "roles/storage.objectUser"
    error_message = "The granted role must match the input."
  }

  assert {
    condition     = google_storage_bucket_iam_member.access["vm"].bucket == "ig-dev-artifacts-x7k2"
    error_message = "Access must be granted on this bucket."
  }
}

run "force_destroy_can_be_enabled" {
  command = plan

  variables {
    force_destroy = true
  }

  assert {
    condition     = google_storage_bucket.this.force_destroy == true
    error_message = "force_destroy must be settable for disposable environments."
  }
}

run "rejects_public_principal" {
  command = plan

  variables {
    object_access = {
      public = {
        member = "allUsers"
        role   = "roles/storage.objectViewer"
      }
    }
  }

  expect_failures = [var.object_access]
}

run "rejects_admin_role" {
  command = plan

  variables {
    object_access = {
      vm = {
        member = "serviceAccount:ig-dev-vm-sa@infragrid-dev-test1.iam.gserviceaccount.com"
        role   = "roles/storage.admin"
      }
    }
  }

  expect_failures = [var.object_access]
}

run "rejects_invalid_suffix" {
  command = plan

  variables {
    suffix = "X7K2"
  }

  expect_failures = [var.suffix]
}

run "rejects_goog_prefix" {
  command = plan

  variables {
    name_prefix = "goog-dev"
  }

  expect_failures = [var.suffix]
}

run "rejects_invalid_region" {
  command = plan

  variables {
    region = "US_CENTRAL1"
  }

  expect_failures = [var.region]
}

run "rejects_zero_retention" {
  command = plan

  variables {
    noncurrent_version_retention_days = 0
  }

  expect_failures = [var.noncurrent_version_retention_days]
}
