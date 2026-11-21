# Environments

## Overview

| Environment | Purpose | Subnet | Bucket force_destroy | Version retention | State of deployment |
|---|---|---|---|---|---|
| dev | Lower environment | 10.10.0.0/24 | true | 7 days | The only environment that will be deployed |
| test | Lower environment | 10.20.0.0/24 | true | 7 days | Validated only |
| run | Production-style | 10.30.0.0/24 | false | 30 days | Validated only |

Every environment has its own root under `environments/`, its own project
ID prefix (`infragrid-<env>-`) and, when deployed, its own GCP project and
state. All three roots call `modules/environment`, which holds the
composition and every per-environment setting (see ADR 0005).

## What "validated, not deployed" means

For test and run, the following is checked on every pull request:

- `terraform fmt`, `terraform init -backend=false` and `terraform validate`
- The root test (`terraform test`) with mock providers
- TFLint
- That the environment name in `main.tf` matches the directory

It does not mean the configuration was ever planned against real GCP or
that any resource exists. Mock tests prove module logic and guards, not that
GCP accepts the configuration.

## Guards against deploying to the wrong environment

- Each root fixes its environment name and requires its project ID to start
  with `infragrid-<env>-`.
- The environment module rejects a project ID that does not match the
  environment, a non-free-tier region and a zone outside the region.
- CI compares each root's environment name with its directory.
- Subnet ranges are distinct per environment.

## Changing an environment setting

Edit `local.settings` in `modules/environment/main.tf` and update its tests
and README in the same pull request. CI then validates all three roots.

## Deploying an environment (future)

Not available yet. Before any real deployment of an environment:

1. A cost and resource review, and your explicit approval.
2. A dedicated GCP project, created as in the project setup runbook.
3. A remote state bucket for that environment (ADR 0002).
4. A separate CI identity (planned for the CI/CD phase).
5. A manual, reviewed apply. Nothing applies automatically.

## Known limits

- On a private repository on GitHub's Free plan, failing checks do not block
  a merge, and branch protection and deployment approvals are unavailable.
  Protection for the run environment is by design and convention (ADR 0003,
  ADR 0005).
- Module tests in CI resolve the newest allowed provider, while roots pin
  exact versions through their lock files (ADR 0004).
