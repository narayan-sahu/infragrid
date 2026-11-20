# 0003: Environment separation

- Status: Accepted
- Date: 2026-11-15
- Amended: 2026-11-16 (roots now call the composition module, see ADR 0005)

## Context

InfraGrid needs lower and production-style environments, and a development
workflow must not be able to change production by accident.

## Decision

- Three environments: dev, test and run (run is the production-style one).
- Separate root configuration directories under environments/, sharing
  modules.
- Separate state and a separate GCP project per environment.
- Terraform workspaces are not used for environment separation.
- Only dev is deployed. Test and run are validated, not deployed.
- Each root fixes its own environment name as a local value and requires its
  project ID to start with `infragrid-<env>-`, so a root cannot be pointed at
  another environment's project by changing an input.

## Alternatives considered

- Workspaces: one backend and one set of credentials, so a wrong workspace
  selection can hit the wrong environment.
- One project with name prefixes: no IAM or billing boundary.

## Consequences

- Thin root configurations are duplicated across environments.
- Three projects to manage, each needing its own billing link.
- Claims about test and run are limited to "validated".
- The word "run" may be confused with Cloud Run, so docs say "the run
  environment".
