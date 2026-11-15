# Module conventions

## Layout

    modules/<name>/
      main.tf
      variables.tf
      outputs.tf
      versions.tf
      README.md
      tests/<name>.tftest.hcl

Add `locals.tf` or `data.tf` only when a module needs them.

## Interface rules

- Modules never contain `provider` blocks. They declare `required_providers`
  in `versions.tf` and inherit the provider from the root.
- Modules do not know about environments. Where a module names resources it
  takes `name_prefix` (the root passes `ig-<env>`) and builds names as
  `${var.name_prefix}-<component>`.
- Resources that support labels take them from a `labels` map variable.
- Every variable has a type and a description. Required inputs have no
  default. Defaults exist only where they are safe.
- Validation blocks check every format the module depends on.
- Outputs expose only what callers need, each with a description, and never
  secrets.
- Secure by default: no external IP, uniform bucket-level access, no public
  access.
- Flags that make teardown harder or easier default to the safe value, and
  the dev root overrides them deliberately.
- No `prevent_destroy`, because every environment must be destroyable.
- No `depends_on` unless an implicit reference cannot express the ordering.
  Comment why when used.

## Documentation

Each module README states its purpose, a table of inputs and outputs, and a
minimal usage example. The tables are maintained by hand, so any interface
change updates the README in the same PR.

## Testing

- Unit tests use `terraform test` with `mock_provider "google" {}`.
- Every `run` block states `command` explicitly. The default is `apply`.
- Each validation rule has one passing and one failing case, the failing one
  using `expect_failures`.
- Assertions check configuration (names, flags, labels), not provider-computed
  values.
- Mock tests prove module logic and validation. They do not prove that GCP
  accepts the configuration. That is covered by real-cloud tests (Phase 10).
- Real-cloud tests do not live in `modules/*/tests/`.

## Linting

TFLint runs with the repository's `.tflint.hcl`. See ADR 0004.
