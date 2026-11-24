# 0005: Environment composition module

- Status: Accepted
- Date: 2026-11-19

## Context

ADR 0003 chose thin root configurations per environment. With four module
calls and non-trivial wiring (IAM identity feeding storage access and the
VM), repeating that composition in three roots lets it drift and repeats
rules such as the free-tier region list.

## Decision

- One module, modules/environment, holds the composition and every
  per-environment difference. Roots under environments/ call it with the
  environment name, project ID, region and zone.
- Project ID, region and zone validation live in this module and are tested
  there.
- This is the only module that knows environment names. Resource modules
  stay environment-agnostic.

## Alternatives considered

- Copy the composition into each root: simplest, but it can drift.
- Terraform workspaces: rejected in ADR 0003.
- Generating roots with a script: adds a tool and a build step.

## Consequences

- One more layer between a root and the resources.
- A copy-paste mistake in a root (the wrong environment name) is still
  possible, because the module cannot see which directory called it. A CI
  check compares each root's environment name with its directory.
- Tests of the module cannot see inside child modules, so they check
  settings and guards through outputs.
- Per-environment differences are reviewed in one file.
