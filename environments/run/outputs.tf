output "vm_name" {
  description = "Name of the run VM."
  value       = module.environment.vm_name
}

output "bucket_name" {
  description = "Name of the run bucket."
  value       = module.environment.bucket_name
}
