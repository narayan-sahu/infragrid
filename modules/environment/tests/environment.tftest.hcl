mock_provider "google" {}
mock_provider "random" {}

variables {
  environment = "dev"
  project_id  = "infragrid-dev-test1"
  region      = "us-central1"
  zone        = "us-central1-a"
}

# No overrides: computed values are unknown, so this proves the composition
# plans with unknown values.
run "plans_with_unknown_values" {
  command = plan

  assert {
    condition     = output.vm_name == "ig-dev-vm-01"
    error_message = "The VM name must not depend on computed values."
  }
}

run "dev_settings" {
  command = plan

  assert {
    condition     = output.subnet_cidr == "10.10.0.0/24" && output.bucket_force_destroy == true && output.bucket_retention_days == 7
    error_message = "dev must use 10.10.0.0/24, a destroyable bucket and 7-day retention."
  }
}

run "test_settings" {
  command = plan

  variables {
    environment = "test"
    project_id  = "infragrid-test-test1"
  }

  assert {
    condition     = output.vm_name == "ig-test-vm-01" && output.subnet_cidr == "10.20.0.0/24" && output.bucket_force_destroy == true && output.bucket_retention_days == 7
    error_message = "test must use ig-test names, 10.20.0.0/24, a destroyable bucket and 7-day retention."
  }
}

run "run_settings" {
  command = plan

  variables {
    environment = "run"
    project_id  = "infragrid-run-test1"
  }

  assert {
    condition     = output.vm_name == "ig-run-vm-01" && output.subnet_cidr == "10.30.0.0/24"
    error_message = "run must use ig-run names and 10.30.0.0/24."
  }

  assert {
    condition     = output.bucket_force_destroy == false && output.bucket_retention_days == 30
    error_message = "run must keep a protected bucket and 30-day retention."
  }
}

run "bucket_name_uses_random_suffix" {
  command = plan

  override_resource {
    target          = random_id.bucket_suffix
    override_during = plan
    values = {
      hex = "a1b2c3"
    }
  }

  assert {
    condition     = output.bucket_name == "ig-dev-artifacts-a1b2c3"
    error_message = "The bucket must use the environment prefix and the random suffix."
  }
}

run "rejects_project_from_another_environment" {
  command = plan

  variables {
    project_id = "infragrid-run-test1"
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

run "rejects_unknown_environment" {
  command = plan

  variables {
    environment = "prod"
    project_id  = "infragrid-prod-test1"
  }

  expect_failures = [var.environment]
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
