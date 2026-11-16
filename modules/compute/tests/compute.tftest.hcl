mock_provider "google" {}

variables {
  name_prefix           = "ig-dev"
  zone                  = "us-central1-a"
  subnet_self_link      = "https://www.googleapis.com/compute/v1/projects/infragrid-dev-test1/regions/us-central1/subnetworks/ig-dev-subnet-main"
  service_account_email = "ig-dev-vm-sa@infragrid-dev-test1.iam.gserviceaccount.com"
  network_tags          = ["ig-iap-ssh"]
}

run "vm_basics" {
  command = plan

  assert {
    condition     = google_compute_instance.this.name == "ig-dev-vm-01"
    error_message = "The VM must be named <prefix>-vm-01."
  }

  assert {
    condition     = google_compute_instance.this.machine_type == "e2-micro" && google_compute_instance.this.zone == "us-central1-a"
    error_message = "The VM must default to e2-micro in the requested zone."
  }
}

run "vm_has_no_external_ip" {
  command = plan

  assert {
    condition     = length(one(google_compute_instance.this.network_interface).access_config) == 0
    error_message = "The VM must not have an external IP address."
  }

  assert {
    condition     = one(google_compute_instance.this.network_interface).subnetwork == var.subnet_self_link
    error_message = "The VM must attach to the requested subnet."
  }
}

run "boot_disk_is_free_tier_standard_disk" {
  command = plan

  assert {
    condition     = one(one(google_compute_instance.this.boot_disk).initialize_params).type == "pd-standard"
    error_message = "The boot disk must be a standard persistent disk."
  }

  assert {
    condition     = one(one(google_compute_instance.this.boot_disk).initialize_params).size == 10
    error_message = "The boot disk must default to 10 GB."
  }
}

run "vm_is_hardened" {
  command = plan

  assert {
    condition = (
      one(google_compute_instance.this.shielded_instance_config).enable_secure_boot == true &&
      one(google_compute_instance.this.shielded_instance_config).enable_vtpm == true &&
      one(google_compute_instance.this.shielded_instance_config).enable_integrity_monitoring == true
    )
    error_message = "All Shielded VM features must be enabled."
  }

  assert {
    condition     = google_compute_instance.this.metadata["enable-oslogin"] == "TRUE"
    error_message = "OS Login must be enabled."
  }

  assert {
    condition     = google_compute_instance.this.can_ip_forward == false
    error_message = "IP forwarding must be disabled."
  }

  assert {
    condition     = one(google_compute_instance.this.scheduling).preemptible == false
    error_message = "The VM must not be preemptible (the free tier requires it)."
  }
}

run "vm_uses_the_given_service_account_and_tags" {
  command = plan

  assert {
    condition     = one(google_compute_instance.this.service_account).email == "ig-dev-vm-sa@infragrid-dev-test1.iam.gserviceaccount.com"
    error_message = "The VM must run as the given service account."
  }

  assert {
    condition     = contains(google_compute_instance.this.tags, "ig-iap-ssh")
    error_message = "The VM must carry the IAP SSH tag."
  }
}

run "labels_are_applied" {
  command = plan

  variables {
    labels = {
      environment = "dev"
    }
  }

  assert {
    condition     = google_compute_instance.this.labels["environment"] == "dev"
    error_message = "Labels must be applied to the VM."
  }
}

run "rejects_unlisted_machine_type" {
  command = plan

  variables {
    machine_type = "n2-standard-8"
  }

  expect_failures = [var.machine_type]
}

run "rejects_oversized_boot_disk" {
  command = plan

  variables {
    boot_disk_size_gb = 100
  }

  expect_failures = [var.boot_disk_size_gb]
}

run "rejects_invalid_zone" {
  command = plan

  variables {
    zone = "us-central1"
  }

  expect_failures = [var.zone]
}

run "rejects_invalid_service_account_email" {
  command = plan

  variables {
    service_account_email = "not-an-email"
  }

  expect_failures = [var.service_account_email]
}

run "rejects_invalid_subnet" {
  command = plan

  variables {
    subnet_self_link = "not-a-subnet"
  }

  expect_failures = [var.subnet_self_link]
}

run "rejects_invalid_network_tag" {
  command = plan

  variables {
    network_tags = ["Bad Tag"]
  }

  expect_failures = [var.network_tags]
}

run "rejects_invalid_boot_image" {
  command = plan

  variables {
    boot_image = "debian"
  }

  expect_failures = [var.boot_image]
}
