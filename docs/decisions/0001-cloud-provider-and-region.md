# 0001: Cloud provider and region

- Status: Accepted
- Date: 2026-11-15 (free-tier details corrected)

## Context

InfraGrid needs one cloud to implement against. The author has existing GCP
exposure and wants a free-first project. Google's free-tier VM and storage
allowances apply only to three US regions (us-west1, us-central1, us-east1).
The e2-micro allowance is limited by time, not VM count: one month of
e2-micro hours per billing account, combined across those regions.
Source: Google Cloud Free Program documentation (last updated 2026-11-13).

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
- VMs running in parallel use the monthly e2-micro hours faster, so one
  short-lived VM at a time stays within the allowance.
- Free-tier terms can change (Google gives 30 days' notice), so they are
  rechecked before each deployment. Last checked 2026-11-13.
- Provider-specific code is limited to the Terraform provider layer and modules.
