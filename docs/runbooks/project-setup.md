# Runbook: set up the dev GCP project

Status: not yet executed. Treat every step as unverified until the first
real deployment.

## Before you start

- Use the Free Trial billing account only. Do not upgrade it.
- Create a budget alert first (budgets send alerts and do not cap spending).
- Confirm no other e2-micro VM runs on this billing account.

## Steps

| # | Step | Command or action | Verify |
|---|---|---|---|
| 1 | Create the project | `gcloud projects create infragrid-dev-<suffix>` | `gcloud projects describe <id>` |
| 2 | Link the trial billing account | `gcloud billing projects link <id> --billing-account=<account>` | `gcloud billing projects describe <id>` |
| 3 | Sign in (first use of credentials) | `gcloud auth application-default login` | `terraform plan` can reach the project |
| 4 | Enable APIs | `gcloud services enable compute.googleapis.com iam.googleapis.com cloudresourcemanager.googleapis.com storage.googleapis.com iap.googleapis.com --project=<id>` | `gcloud services list --enabled --project=<id>` |
| 5 | Remove the default network | Delete its firewall rules (`default-allow-ssh`, `default-allow-rdp`, `default-allow-icmp`, `default-allow-internal`), then `gcloud compute networks delete default` | `gcloud compute networks list` |
| 6 | Check the boot image | `gcloud compute images list --project=debian-cloud --no-standard-images --filter="family:debian-12"` | A non-deprecated image is listed |
| 7 | Plan | Copy `terraform.tfvars.example` to `terraform.tfvars`, set `project_id`, then `terraform plan -out=tfplan` | Review every resource against the cost review |
| 8 | Apply | `terraform apply tfplan` | Resources exist, no external IP on the VM |
| 9 | Connect | `gcloud compute ssh ig-dev-vm-01 --zone us-central1-a --tunnel-through-iap` | A shell opens |
| 10 | Tear down | `terraform destroy`, then check the console for leftovers | No resources remain |

## Notes

- A new project's default network ships permissive firewall rules that allow
  SSH, RDP and ICMP from anywhere. InfraGrid's VM is not on that network.
  Removing it is hygiene, not a requirement.
- Required API names other than Compute Engine are unconfirmed. Terraform
  errors name any API that is missing.
- OS Login behavior for a project Owner is unconfirmed (step 9).
- Bucket names can stay reserved after a project is deleted.
- Capture evidence before the trial ends: after 90 days or $300, resources
  stop and are deleted after a grace period.
