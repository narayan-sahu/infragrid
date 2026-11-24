output "vm_name" {
  description = "Name of the environment's VM."
  value       = module.compute.instance_name
}

output "bucket_name" {
  description = "Name of the environment's bucket."
  value       = module.storage.bucket_name
}

output "subnet_cidr" {
  description = "IPv4 range of the environment's subnet, as applied to the subnet."
  value       = module.networking.subnet_cidr
}

output "bucket_force_destroy" {
  description = "Whether the bucket may be deleted while it contains objects, as applied to the bucket."
  value       = module.storage.force_destroy
}

output "bucket_retention_days" {
  description = "Days before non-current bucket object versions are deleted, as applied to the bucket."
  value       = module.storage.noncurrent_version_retention_days
}
