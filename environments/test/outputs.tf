output "vm_name" {
  description = "Name of the test VM."
  value       = module.compute.instance_name
}

output "bucket_name" {
  description = "Name of the test bucket."
  value       = module.storage.bucket_name
}
