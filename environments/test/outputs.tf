output "vm_name" {
  description = "Name of the test VM."
  value       = module.environment.vm_name
}

output "bucket_name" {
  description = "Name of the test bucket."
  value       = module.environment.bucket_name
}
