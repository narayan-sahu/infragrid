mock_provider "google" {}
mock_provider "random" {}

variables {
  project_id = "infragrid-run-test1"
}

# No overrides: computed values (service account email, subnet link, bucket
# suffix) are unknown here, so this run proves the composition plans with
# unknown values, including the static-key object_access design.
run "plans_with_unknown_values" {
  command = plan

  assert {
    condition     = output.vm_name == "ig-run-vm-01"
    error_message = "The VM name must not depend on computed values."
  }
}

run "dev_composes_all_modules" {
  command = plan

  override_resource {
    target          = random_id.bucket_suffix
    override_during = plan
    values = {
      hex = "a1b2c3"
    }
  }

  override_resource {
    target          = module.iam.google_service_account.this["vm"]
    override_during = plan
    values = {
      email = "ig-run-vm-sa@infragrid-run-test1.iam.gserviceaccount.com"
    }
  }

  override_resource {
    target          = module.networking.google_compute_subnetwork.main
    override_during = plan
    values = {
      self_link = "https://www.googleapis.com/compute/v1/projects/infragrid-run-test1/regions/us-central1/subnetworks/ig-run-subnet-main"
    }
  }

  assert {
    condition     = output.vm_name == "ig-run-vm-01"
    error_message = "The VM must be named ig-run-vm-01."
  }

  assert {
    condition     = output.bucket_name == "ig-run-artifacts-a1b2c3"
    error_message = "The bucket must use the run prefix and the random suffix."
  }
}

run "rejects_project_from_another_environment" {
  command = plan

  variables {
    project_id = "infragrid-dev-test1"
  }

  expect_failures = [var.project_id]
}

run "rejects_malformed_project_id" {
  command = plan

  variables {
    project_id = "BAD_ID"
  }

  expect_failures = [var.project_id]
}

run "rejects_non_free_tier_region" {
  command = plan

  variables {
    region = "asia-south1"
    zone   = "asia-south1-a"
  }

  expect_failures = [var.region]
}

run "rejects_zone_outside_region" {
  command = plan

  variables {
    zone = "us-east1-b"
  }

  expect_failures = [var.zone]
}
