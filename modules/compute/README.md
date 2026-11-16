# compute

One hardened Compute Engine VM that runs as a dedicated service account and
has no external IP address.

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `name_prefix` | string | none | Prefix, for example `ig-dev`. The VM is `<prefix>-vm-01`. |
| `zone` | string | none | Zone, for example `us-central1-a` |
| `subnet_self_link` | string | none | Subnet the VM attaches to |
| `service_account_email` | string | none | Service account the VM runs as |
| `network_tags` | list(string) | `[]` | Network tags, for example the IAP SSH tag |
| `machine_type` | string | `e2-micro` | `e2-micro`, `e2-small` or `e2-medium` |
| `boot_disk_size_gb` | number | `10` | 10-30 GB |
| `boot_image` | string | `debian-cloud/debian-12` | `<project>/<family>` |
| `labels` | map(string) | `{}` | Labels applied to the VM |

## Outputs

| Name | Description |
|---|---|
| `instance_name` | Name of the VM |
| `instance_self_link` | Self link of the VM |

## Usage

    module "compute" {
      source                = "../../modules/compute"
      name_prefix           = "ig-dev"
      zone                  = "us-central1-a"
      subnet_self_link      = module.networking.subnet_self_link
      service_account_email = module.iam.service_account_emails["vm"]
      network_tags          = [module.networking.iap_ssh_tag]
      labels                = local.common_labels
    }

## Guardrails

- No external IP, and no way to add one.
- Standard persistent boot disk, 10-30 GB (free-tier sized).
- Shielded VM (secure boot, vTPM, integrity monitoring) and OS Login on.
- Non-preemptible, as the free tier requires.
- The service account is required. The VM never uses the default one.
- `deletion_protection` is off so environments can be destroyed.

## Notes

- The default image family should be rechecked before each deployment.
- Tests: `terraform test` from this directory. They use a mock provider and
  need no credentials.
