locals {
  # Source range Google uses for IAP TCP forwarding.
  iap_source_ranges = ["35.235.240.0/20"]
}

resource "google_compute_network" "main" {
  name                    = "${var.name_prefix}-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "main" {
  name                     = "${var.name_prefix}-subnet-main"
  region                   = var.region
  network                  = google_compute_network.main.id
  ip_cidr_range            = var.subnet_cidr
  private_ip_google_access = true
}

resource "google_compute_firewall" "allow_iap_ssh" {
  name      = "${var.name_prefix}-fw-allow-iap-ssh"
  network   = google_compute_network.main.id
  direction = "INGRESS"
  priority  = 1000

  source_ranges = local.iap_source_ranges
  target_tags   = [var.iap_ssh_tag]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
