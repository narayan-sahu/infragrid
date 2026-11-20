output "vm_name" {
  description = "Name of the run VM."
  value       = module.compute.instance_name
}

output "bucket_name" {
  description = "Name of the run bucket."
  value       = module.storage.bucket_name
}
