# environment

Composes the networking, iam, storage and compute modules for one
environment. All per-environment differences live in `local.settings`.

This is the only module that knows the environment names. The resource
modules stay environment-agnostic.

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `environment` | string | none | `dev`, `test` or `run` |
| `project_id` | string | none | Must start with `infragrid-<environment>-` |
| `region` | string | `us-central1` | Free-tier US regions only |
| `zone` | string | `us-central1-a` | Must be inside the region |

## Outputs

| Name | Description |
|---|---|
| `vm_name` | Name of the VM |
| `bucket_name` | Name of the bucket |
| `subnet_cidr` | Subnet range for the environment |
| `bucket_force_destroy` | Whether the bucket may be deleted while non-empty |
| `bucket_retention_days` | Days before non-current versions are deleted |

## Per-environment settings

| Environment | Subnet | Bucket force_destroy | Version retention |
|---|---|---|---|
| dev | 10.10.0.0/24 | true | 7 days |
| test | 10.20.0.0/24 | true | 7 days |
| run | 10.30.0.0/24 | false | 30 days |

## Usage

    module "environment" {
      source      = "../../modules/environment"
      environment = "dev"
      project_id  = var.project_id
      region      = var.region
      zone        = var.zone
    }

## Notes

- A root must pass the environment that matches its directory. A CI check
  compares each root's environment name with its directory.
- Tests: `terraform test` from this directory. They use mock providers and
  need no credentials.
