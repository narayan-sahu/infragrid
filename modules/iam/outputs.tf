output "service_account_emails" {
  description = "Email address of each service account, keyed by the input key."
  value       = { for key, sa in google_service_account.this : key => sa.email }
}

output "service_account_members" {
  description = "IAM member string (serviceAccount:<email>) of each service account, keyed by the input key."
  value       = { for key, sa in google_service_account.this : key => "serviceAccount:${sa.email}" }
}
