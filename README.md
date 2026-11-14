# InfraGrid

**Design. Provision. Secure. Automate.**

InfraGrid is a Terraform-based infrastructure automation project for GCP,
covering reusable modules, CI/CD validation, security scanning, policy
enforcement, drift detection and cost governance.

## Status

No infrastructure has been deployed to GCP. The work so far is design and a
validated Terraform foundation.

| Component | State |
|---|---|
| Repository standards, PR template, pre-commit hooks | Implemented |
| `environments/dev` foundation (versions, provider, validated inputs) | Implemented, validated locally with `terraform fmt` and `terraform validate`. Declares no resources. |
| Architecture decisions (ADR 0001-0003) | Written |
| Terraform modules (networking, IAM, compute, storage) | Planned |
| `test` and `run` environment roots | Planned |
| GitHub Actions workflows | Planned |
| Checkov scanning, OPA/Conftest policies | Planned |
| Drift detection, Infracost cost estimates | Planned |

## Environments

| Environment | Purpose | Deployment |
|---|---|---|
| `dev` | Lower environment | The only one that will be deployed |
| `test` | Lower environment | Validated only |
| `run` | Production-style environment | Validated only |

Each environment gets its own root configuration, state and GCP project.

## Cost approach

Free-first: local validation wherever possible, and cloud resources only in
the free-tier US regions (us-west1, us-central1, us-east1), created briefly
and destroyed after testing. See ADR 0001.

## Local checks

Prerequisites: Git, Terraform 1.17 or newer, Python (for pre-commit).

    pre-commit install
    pre-commit run --all-files
    cd environments/dev
    terraform init -backend=false
    terraform fmt -check -recursive
    terraform validate

## Repository layout

- `environments/dev/`: Terraform root configuration for dev
- `docs/decisions/`: architecture decision records

More directories are added as each phase is implemented.
