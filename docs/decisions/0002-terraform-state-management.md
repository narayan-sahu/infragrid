# 0002: Terraform state management

- Status: Accepted (not yet implemented; local state in use)
- Date: 2026-11-15

## Context

State records what Terraform manages and can contain sensitive values.
Local state has no locking or sharing and is lost with the disk.

## Decision

- Use local, git-ignored state until the first cloud deployment.
- Then use a GCS backend: one bucket per environment, in that environment's
  project, with versioning, uniform bucket-level access, no public access and
  restricted IAM.
- Create the buckets with a separate bootstrap configuration that keeps its
  own state local and uncommitted.

## Alternatives considered

- One shared bucket with a prefix per environment: simpler, but a single
  access boundary for all environments.
- HCP Terraform: adds an external dependency and account.
- Local state only: no locking and no CI use.

## Consequences

- The bootstrap step is a documented chicken-and-egg exception.
- Losing bootstrap state means re-importing or recreating the bucket.
- State buckets draw on the same small free storage allowance.
- Teardown order: destroy the environment first, then its state bucket.
