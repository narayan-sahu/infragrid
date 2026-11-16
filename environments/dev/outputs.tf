output "vm_name" {
  description = "Name of the dev VM."
  value       = module.compute.instance_name
}

output "bucket_name" {
  description = "Name of the dev bucket."
  value       = module.storage.bucket_name
}
