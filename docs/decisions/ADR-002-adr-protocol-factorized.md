# ADR-002: ADR protocol factorized in agents/_adr-protocol.md

**Date:** 2026-03-23
**Status:** Accepted

## Decision
The ADR detection protocol and creation template are defined once in `agents/_adr-protocol.md`. All agents and skills that need ADR logic reference this single file instead of inlining their own copy.

## Rationale
- The protocol was duplicated across 4 files (senior-engineer, code-reviewer, verifier, sc-adr) with slight divergences
- A single source of truth prevents silent drift between detection criteria or template formats

## Consequences
- Any change to ADR behavior requires editing only one file
- Agents depend on `agents/_adr-protocol.md` existing — deleting it breaks ADR detection across the system

## DO NOT
- Do not inline ADR detection criteria or templates in individual agents — always reference `_adr-protocol.md`
- Do not rename or move `agents/_adr-protocol.md` without updating all 4 referencing files

## Triggers
Re-evaluate if: the ADR protocol needs to diverge between agents (e.g., different detection criteria for review vs. analysis)
