# iam

Creates service accounts and grants each one only the project roles listed.
Never creates service account keys.

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `name_prefix` | string | none | Prefix for names, for example `ig-dev` |
| `project_id` | string | none | Project where project-level roles are granted |
| `service_accounts` | map(object) | none | Accounts to create, keyed by a short name. Each object has `description` and optional `project_roles`. |

## Outputs

| Name | Description |
|---|---|
| `service_account_emails` | Email of each account, keyed by input key |
| `service_account_members` | `serviceAccount:<email>` of each account, keyed by input key |

## Usage

    module "iam" {
      source      = "../../modules/iam"
      name_prefix = "ig-dev"
      project_id  = var.project_id
      service_accounts = {
        vm = {
          description = "Identity of the dev VM"
        }
      }
    }

## Guardrails

- Project roles must be listed explicitly. The default is none.
- Basic roles (owner, editor, viewer), `roles/iam.*` and
  `roles/resourcemanager.projectIamAdmin` are rejected. A genuine need goes
  through the security exception process.
- Grants are additive (`google_project_iam_member`), so they never replace
  other principals' access.

## Notes

- Human SSH access is not managed here. A project Owner already has IAP
  access.
- The IAM API must be enabled on the project (see the project setup runbook).
- Tests: `terraform test` from this directory. They use a mock provider and
  need no credentials.
