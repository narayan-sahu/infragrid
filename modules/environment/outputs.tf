output "vm_name" {
  description = "Name of the environment's VM."
  value       = module.compute.instance_name
}

output "bucket_name" {
  description = "Name of the environment's bucket."
  value       = module.storage.bucket_name
}

output "subnet_cidr" {
  description = "IPv4 range of the environment's subnet."
  value       = local.current.subnet_cidr
}

output "bucket_force_destroy" {
  description = "Whether the bucket may be deleted while it contains objects."
  value       = local.current.force_destroy
}

output "bucket_retention_days" {
  description = "Days before non-current bucket object versions are deleted."
  value       = local.current.retention_days
}
