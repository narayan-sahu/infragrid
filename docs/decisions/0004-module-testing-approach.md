# 0004: Module testing approach

- Status: Accepted
- Date: 2026-11-15

## Context

InfraGrid modules need repeatable tests that run locally and in CI without a
cloud account or cost. Terraform provides native tests with mock providers
(Terraform 1.7 and later).

## Decision

- Unit-test modules with `terraform test` and `mock_provider "google"`.
- Every run block sets `command` explicitly, because the default is `apply`.
- Real-cloud integration tests are separate, approved individually and use
  the dev project only.
- Lint with TFLint (bundled Terraform ruleset plus the Google ruleset).

## Alternatives considered

- Terratest: Go-based and typically deploys real infrastructure, so it
  needs a toolchain, credentials and has cost exposure.
- Real-cloud tests only: realistic, but slow, billable and unusable before
  a GCP project exists.
- Local emulator (floci-gcp): covers storage and IAM but not networking or
  compute. Revisit at Task 4.4.

## Consequences

- Mock tests do not prove that GCP accepts a configuration.
- Tests run in seconds with no credentials.
- Provider-computed values must be overridden in tests that depend on them.
- One more tool (TFLint) in local setup and CI.
