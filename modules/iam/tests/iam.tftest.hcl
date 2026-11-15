mock_provider "google" {}

variables {
  name_prefix = "ig-dev"
  project_id  = "infragrid-dev-test1"
  service_accounts = {
    vm = {
      description = "Identity of the dev VM"
    }
  }
}

run "creates_service_account_with_expected_id" {
  command = plan

  assert {
    condition     = length(google_service_account.this) == 1
    error_message = "Exactly one service account must be created."
  }

  assert {
    condition     = google_service_account.this["vm"].account_id == "ig-dev-vm-sa"
    error_message = "Account ID must be <prefix>-<key>-sa."
  }
}

run "grants_no_project_roles_by_default" {
  command = plan

  assert {
    condition     = length(google_project_iam_member.this) == 0
    error_message = "No project roles may be granted unless listed."
  }
}

run "grants_only_listed_roles" {
  command = plan

  variables {
    service_accounts = {
      vm = {
        description   = "Identity of the dev VM"
        project_roles = ["roles/logging.logWriter"]
      }
    }
  }

  assert {
    condition     = length(google_project_iam_member.this) == 1
    error_message = "Exactly the listed role must be granted."
  }

  assert {
    condition     = google_project_iam_member.this["vm|roles/logging.logWriter"].role == "roles/logging.logWriter"
    error_message = "The granted role must match the input."
  }

  assert {
    condition     = google_project_iam_member.this["vm|roles/logging.logWriter"].project == "infragrid-dev-test1"
    error_message = "The role must be granted on the requested project."
  }
}

run "outputs_member_strings" {
  command = plan

  override_resource {
    target          = google_service_account.this["vm"]
    override_during = plan
    values = {
      email = "ig-dev-vm-sa@infragrid-dev-test1.iam.gserviceaccount.com"
    }
  }

  assert {
    condition     = output.service_account_members["vm"] == "serviceAccount:ig-dev-vm-sa@infragrid-dev-test1.iam.gserviceaccount.com"
    error_message = "Member string must be serviceAccount:<email>."
  }
}

run "rejects_basic_roles" {
  command = plan

  variables {
    service_accounts = {
      vm = {
        description   = "Identity of the dev VM"
        project_roles = ["roles/editor"]
      }
    }
  }

  expect_failures = [var.service_accounts]
}

run "rejects_iam_administration_roles" {
  command = plan

  variables {
    service_accounts = {
      vm = {
        description   = "Identity of the dev VM"
        project_roles = ["roles/iam.serviceAccountAdmin"]
      }
    }
  }

  expect_failures = [var.service_accounts]
}

run "rejects_overlong_account_id" {
  command = plan

  variables {
    service_accounts = {
      a-very-long-service-account-key = {
        description = "Too long"
      }
    }
  }

  expect_failures = [var.service_accounts]
}

run "rejects_invalid_name_prefix" {
  command = plan

  variables {
    name_prefix = "IG_DEV"
  }

  expect_failures = [var.name_prefix]
}

run "rejects_invalid_project_id" {
  command = plan

  variables {
    project_id = "BAD_ID"
  }

  expect_failures = [var.project_id]
}
