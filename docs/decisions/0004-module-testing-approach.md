# 0004: Module testing approach

- Status: Accepted
- Date: 2026-11-15
- Amended: 2026-11-24 (evidence updated)

## Context

InfraGrid modules need repeatable tests that run locally and in CI without a
cloud account or cost. Terraform provides native tests with mock providers
(Terraform 1.7 and later).

## Decision

- Unit-test modules with `terraform test` and `mock_provider "google"`.
- Every run block sets `command` explicitly, because the default is `apply`.
- Supply provider-computed values with `override_resource` and
  `override_during = plan` (Terraform 1.11 and later).
- Real-cloud integration tests are separate, approved individually and use
  the dev project only.
- Lint with TFLint (bundled Terraform ruleset plus the Google ruleset).

## Evidence

Local runs passed with a mock Google provider and no GCP account:
networking 7, iam 9, storage 14, compute 14, environment 10, and 3 each for
the dev, test and run roots (63 runs). The iam, environment and root suites
use `override_during = plan`. The environment and root suites include a run
without overrides, which plans with unknown computed values.

## Alternatives considered

- Terratest: Go-based and typically deploys real infrastructure, so it
  needs a toolchain, credentials and has cost exposure.
- Real-cloud tests only: realistic, but slow, billable and unusable before
  a GCP project exists.
- Local emulator (floci-gcp): covers storage and IAM but not networking or
  compute. Revisit in Phase 8 (drift detection).

## Consequences

- Mock tests do not prove that GCP accepts a configuration.
- Tests run in seconds with no credentials.
- Tests that depend on computed values need an override.
- Module tests in CI run `terraform init` without a lock file, so they
  resolve the newest provider version allowed by `~> 8.0`. This can surface
  provider changes early, and it can also cause failures that need no code
  change. Roots pin exact versions through their lock files.
- One more tool (TFLint) in local setup and CI.
