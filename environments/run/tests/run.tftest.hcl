mock_provider "google" {}
mock_provider "random" {}

variables {
  project_id = "infragrid-run-test1"
}

run "plans_with_unknown_values" {
  command = plan

  assert {
    condition     = output.vm_name == "ig-run-vm-01"
    error_message = "The run root must plan with unknown computed values and name the VM ig-run-vm-01."
  }
}

run "run_uses_the_run_settings" {
  command = plan

  override_resource {
    target          = module.environment.random_id.bucket_suffix
    override_during = plan
    values = {
      hex = "a1b2c3"
    }
  }

  assert {
    condition     = output.bucket_name == "ig-run-artifacts-a1b2c3"
    error_message = "The run root must produce the ig-run bucket name."
  }
}

run "rejects_project_from_another_environment" {
  command = plan

  variables {
    project_id = "infragrid-dev-test1"
  }

  expect_failures = [var.project_id]
}
