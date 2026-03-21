# ADR-001: sc-audit is a SoloCraft-internal maintenance tool

## Status

Accepted

## Date

2026-03-21

## Context

SoloCraft distributes skills to target projects via `install.sh`, which maintains a `SKILLS` array listing skills to deploy and symlink. The `sc-audit` skill was created as a maintenance utility to inspect and validate the SoloCraft installation itself — not to operate on target projects.

Deploying `sc-audit` to target projects would:
- expose SoloCraft internals in environments where they have no purpose
- create dead symlinks if SoloCraft is not installed in the target project's context
- pollute the target project's `.claude/skills/` with a tool that operates on SoloCraft, not on the project

## Decision

`sc-audit` is classified as a SoloCraft-internal maintenance tool. It is excluded from the `SKILLS` array in `install.sh` and must not be deployed or symlinked to any target project.

The skill remains available exclusively within the SoloCraft repository itself, invoked directly by maintainers of SoloCraft.

## Consequences

- `install.sh` must never include `sc-audit` in the `SKILLS` array.
- Any future internal-only skill follows the same convention: omit from `SKILLS`, document the exclusion in `docs/decisions/`.
- Target projects have no awareness of `sc-audit`.
- SoloCraft maintainers invoke `sc-audit` from within the SoloCraft repository only.
