resource "google_compute_instance" "this" {
  name         = "${var.name_prefix}-vm-01"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = var.network_tags
  labels       = var.labels

  can_ip_forward            = false
  allow_stopping_for_update = true
  deletion_protection       = false

  metadata = {
    enable-oslogin         = "TRUE"
    block-project-ssh-keys = "TRUE"
  }

  boot_disk {
    initialize_params {
      image = var.boot_image
      size  = var.boot_disk_size_gb
      type  = "pd-standard"
    }
  }

  network_interface {
    subnetwork = var.subnet_self_link
    # No access_config block on purpose: the VM gets no external IP address.
  }

  scheduling {
    preemptible         = false
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }
}
