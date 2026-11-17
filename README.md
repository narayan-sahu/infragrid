# InfraGrid

**Design. Provision. Secure. Automate.**

InfraGrid is a Terraform-based infrastructure automation project for GCP,
covering reusable modules, CI/CD validation, security scanning, policy
enforcement, drift detection and cost governance.

## Status

No infrastructure has been deployed to GCP. Everything below marked
"Implemented" is validated locally and in CI with mock providers only.

| Component | State |
|---|---|
| Repository standards, PR template, pre-commit hooks | Implemented |
| Modules: networking, iam, storage, compute (unit tests with mock providers) | Implemented |
| `environments/dev` composing the four modules | Implemented, plan-tested with mock providers. Not applied. |
| GitHub Actions: pre-commit, terraform-test, terraform-validate, tflint | Implemented |
| Architecture decisions (ADR 0001-0004) | Written |
| First real deployment of `dev` | Planned (needs a cost review and approval) |
| `test` and `run` environment roots | Planned |
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

Prerequisites: Git, Terraform 1.17 or newer, Python (for pre-commit), TFLint.

    pre-commit install
    pre-commit run --all-files
    cd environments/dev
    terraform init -backend=false
    terraform fmt -check -recursive
    terraform validate
    terraform test

Each module runs its own tests with `terraform test` from its directory.

## Repository layout

- `environments/dev/`: root configuration composing the modules
- `modules/`: networking, iam, storage, compute
- `docs/decisions/`: architecture decision records
- `docs/guides/`: naming and module conventions
- `.github/workflows/`: CI workflows
