mock_provider "google" {}

variables {
  name_prefix = "ig-dev"
  region      = "us-central1"
  subnet_cidr = "10.10.0.0/24"
}

run "network_is_custom_mode" {
  command = plan

  assert {
    condition     = google_compute_network.main.auto_create_subnetworks == false
    error_message = "The VPC must use custom subnet mode."
  }

  assert {
    condition     = google_compute_network.main.name == "ig-dev-vpc"
    error_message = "The VPC must be named <prefix>-vpc."
  }
}

run "subnet_uses_private_google_access" {
  command = plan

  assert {
    condition     = google_compute_subnetwork.main.private_ip_google_access == true
    error_message = "Private Google Access must be enabled."
  }

  assert {
    condition     = google_compute_subnetwork.main.ip_cidr_range == "10.10.0.0/24"
    error_message = "The subnet must use the requested range."
  }
}

run "ssh_allowed_only_from_iap" {
  command = plan

  assert {
    condition     = length(google_compute_firewall.allow_iap_ssh.source_ranges) == 1 && contains(google_compute_firewall.allow_iap_ssh.source_ranges, "35.235.240.0/20")
    error_message = "SSH must be allowed only from the IAP range."
  }

  assert {
    condition     = one(google_compute_firewall.allow_iap_ssh.allow).protocol == "tcp" && length(one(google_compute_firewall.allow_iap_ssh.allow).ports) == 1 && contains(one(google_compute_firewall.allow_iap_ssh.allow).ports, "22")
    error_message = "Only TCP port 22 may be allowed."
  }

  assert {
    condition     = contains(google_compute_firewall.allow_iap_ssh.target_tags, "ig-iap-ssh")
    error_message = "The rule must target the IAP SSH tag."
  }
}

run "rejects_public_cidr" {
  command = plan

  variables {
    subnet_cidr = "8.8.8.0/24"
  }

  expect_failures = [var.subnet_cidr]
}

run "rejects_invalid_name_prefix" {
  command = plan

  variables {
    name_prefix = "IG_DEV"
  }

  expect_failures = [var.name_prefix]
}

run "rejects_invalid_tag" {
  command = plan

  variables {
    iap_ssh_tag = "Bad Tag"
  }

  expect_failures = [var.iap_ssh_tag]
}


run "exposes_the_configured_subnet_range" {
  command = plan

  variables {
    subnet_cidr = "10.20.0.0/24"
  }

  assert {
    condition     = output.subnet_cidr == "10.20.0.0/24"
    error_message = "The subnet_cidr output must report the applied range."
  }
}
