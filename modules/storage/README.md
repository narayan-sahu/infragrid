# storage

One private, versioned, Standard-class Cloud Storage bucket with a lifecycle
rule that expires old object versions, and optional bucket-level access for
named identities.

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `name_prefix` | string | none | Prefix, for example `ig-dev` |
| `purpose` | string | none | Short purpose, for example `artifacts` |
| `suffix` | string | none | Random 4-8 character suffix (not derived from the project ID) |
| `region` | string | none | Bucket region, for example `us-central1` |
| `labels` | map(string) | `{}` | Labels applied to the bucket |
| `force_destroy` | bool | `false` | Allow deleting a non-empty bucket |
| `noncurrent_version_retention_days` | number | `7` | Days before non-current versions are deleted |
| `object_access` | map(object) | `{}` | Bucket-level access, keyed by a static label |

## Outputs

| Name | Description |
|---|---|
| `bucket_name` | Name of the bucket |
| `bucket_self_link` | Self link of the bucket |
| `force_destroy` | Whether the bucket may be deleted while non-empty |
| `noncurrent_version_retention_days` | Days before non-current versions are deleted |

## Usage

    module "storage" {
      source      = "../../modules/storage"
      name_prefix = "ig-dev"
      purpose     = "artifacts"
      suffix      = random_id.bucket.hex
      region      = var.region
      labels      = local.common_labels
      object_access = {
        vm = {
          member = module.iam.service_account_members["vm"]
          role   = "roles/storage.objectUser"
        }
      }
    }

## Guardrails

- Fixed: uniform bucket-level access, enforced public access prevention,
  Standard storage class, versioning on, Google-managed encryption.
- Access roles are limited to objectViewer, objectCreator and objectUser.
  Admin roles and public principals are rejected.
- `object_access` keys must be known at plan time (use a fixed label such as
  `vm`). Values may be computed.

## Notes

- Free-tier storage is 5 GB-months in the three US regions. Keep data small.
- Tests: `terraform test` from this directory. They use a mock provider and
  need no credentials.
