# 0001: Cloud provider and region

- Status: Accepted
- Date: 2026-11-15

## Context

InfraGrid needs one cloud to implement against. The author has existing GCP
exposure and wants a free-first project. Google's free-tier VM and storage
allowances apply only to three US regions (us-west1, us-central1, us-east1),
and only one free e2-micro VM exists per billing account across all regions.

## Decision

- GCP is the only implementation cloud.
- Deploy only to free-tier US regions, defaulting to us-central1.
- AWS and Azure equivalents are documented, not deployed.

## Alternatives considered

- AWS or Azure: less existing exposure, no benefit for the project's goals.
- Asia Pacific regions: closer to the author, but outside the free tier, so
  every resource would consume trial credit.

## Consequences

- Higher latency from the author's location, which does not matter here.
- Only one free VM can run at a time across all environments.
- Free-tier terms can change, so they are rechecked before each deployment.
- Provider-specific code is limited to the Terraform provider layer and modules.
