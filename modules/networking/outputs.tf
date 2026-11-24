output "network_self_link" {
  description = "Self link of the VPC network."
  value       = google_compute_network.main.self_link
}

output "subnet_self_link" {
  description = "Self link of the subnet."
  value       = google_compute_subnetwork.main.self_link
}

output "iap_ssh_tag" {
  description = "Network tag that grants IAP SSH access to an instance."
  value       = var.iap_ssh_tag
}

output "subnet_cidr" {
  description = "IPv4 range of the subnet."
  value       = google_compute_subnetwork.main.ip_cidr_range
}
