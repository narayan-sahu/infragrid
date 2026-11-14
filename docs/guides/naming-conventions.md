# Naming conventions

## Environments

`dev`, `test` and `run` (`run` is the production-style environment). In prose
write "the run environment" to avoid confusion with Cloud Run.

## Patterns

| Item | Pattern | Example |
|---|---|---|
| GCP project ID | `infragrid-<env>-<suffix>` | `infragrid-dev-x7k2` |
| Resource name | `ig-<env>-<component>[-<nn>]` | `ig-dev-vpc`, `ig-dev-vm-01` |
| Bucket name | `ig-<env>-<purpose>-<suffix>` | `ig-dev-artifacts-x7k2` |
| Service account ID | `ig-<env>-<role>-sa` | `ig-dev-vm-sa` |
| Terraform identifier | lowercase `snake_case`, named for its role | `google_compute_network.main` |

The suffix is a short random string, so names stay unique and unguessable.
The dev root enforces the `infragrid-dev-` project ID prefix.

## GCP rules (verified against Google documentation, 2026-11-15)

Project IDs: 6-30 lowercase letters, digits and hyphens; must start with a
letter; no trailing hyphen.

Compute Engine resources (VMs, networks, firewall rules and similar): 1-63
characters, matching `^[a-z]([-a-z0-9]*[a-z0-9])?`. VM names must be unique
across a project unless the project's `vmDnsSetting` is `ZonalOnly`.

Service account IDs: 6-30 characters, lowercase letters, digits and dashes.
The ID cannot be changed after creation.

Buckets:
- 3-63 characters; lowercase letters, digits, dashes, underscores, dots.
- Must start and end with a letter or digit.
- Globally unique and publicly visible. Google advises against putting
  project names, project numbers or personal data in bucket names.
- Cannot begin with "goog" or contain "google" or close misspellings.
- A deleted bucket's name may not be released for weeks if its whole project
  is deleted.

Labels:
- At most 64 labels per resource.
- Keys: 1-63 characters, starting with a lowercase letter.
- Values: at most 63 characters.
- Only lowercase letters, digits, underscores and dashes.

## Mandatory labels

Every resource that supports labels carries `project`, `environment` and
`managed_by`, set from the common labels in each root. Some resources, such
as VPC networks and firewall rules, do not support labels.

## Git and CI

- Branches: `feature/`, `fix/`, `docs/`, `chore/` + short hyphenated name.
- Commits: Conventional Commits, for example
  `feat(terraform): add networking module`.
  Types: feat, fix, docs, chore, ci, test, refactor.
- Workflow files: lowercase, hyphen-separated, for example
  `terraform-plan.yml`.
- ADRs: `NNNN-short-title.md`, numbered in order.
