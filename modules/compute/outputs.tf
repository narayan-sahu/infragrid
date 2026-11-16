output "instance_name" {
  description = "Name of the VM."
  value       = google_compute_instance.this.name
}

output "instance_self_link" {
  description = "Self link of the VM."
  value       = google_compute_instance.this.self_link
}
