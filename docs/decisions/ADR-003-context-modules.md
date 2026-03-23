# ADR-003: context-modules as opt-in convention for domain context mapping

**Date:** 2026-03-23
**Status:** Accepted

## Decision
The `## SoloCraft` section in a project's CLAUDE.md may contain an optional `### context-modules` subsection that maps domain names to context files. Agents load the relevant modules when present.

## Rationale
- Tests proved that agents with only the SoloCraft section can detect risk but cannot evaluate the substance of a change
- With context-modules, agents load domain knowledge (scoring rules, frontend conventions, lessons learned) and produce complete analyses
- The pattern keeps SoloCraft generic — the mapping lives in the project's CLAUDE.md, not in the agents

## Consequences
- Projects that modularize their context get richer agent output
- Projects without context-modules work exactly as before (backward-compatible)
- Each agent's CLAUDE.md extraction step now includes a conditional load instruction

## DO NOT
- Do not make context-modules mandatory — many projects put everything in CLAUDE.md and that works
- Do not add module resolution logic in SoloCraft — the routing stays in the project's CLAUDE.md
- Do not reference specific context file paths in agents — the mapping is project-specific

## Triggers
Re-evaluate if: agents develop a reliable way to auto-discover domain context files without explicit mapping
