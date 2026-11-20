output "vm_name" {
  description = "Name of the dev VM."
  value       = module.environment.vm_name
}

output "bucket_name" {
  description = "Name of the dev bucket."
  value       = module.environment.bucket_name
}
