# ADR Protocol

Référence unique pour la détection et la création d'ADRs. Utilisé par : senior-engineer, code-reviewer, verifier, sc-adr.

## Detection

Flag `ADR REQUIRED` if any of the following is true:
- A value, constant, or behavior is changing for a non-obvious reason
- An apparently reasonable approach is being rejected in favor of another
- An implicit rule or convention is being established
- A previously intentional behavior is being modified
- A limitation is discovered that others might try to work around

Format: `ADR REQUIRED — [one-line reason]`

## Creation

1. Find the decisions directory (from CLAUDE.md section SoloCraft `decisions-dir`).
2. Determine the next ADR number (highest existing + 1, starting at ADR-001).
3. Use the ADR format specified in CLAUDE.md under `adr-format`. If none, use:

```
# ADR-NNN: [Title]

**Date:** YYYY-MM-DD
**Status:** Accepted

## Decision
[1-2 sentences: what was decided]

## Rationale
- [why this approach over alternatives]
- [constraint or context that drove the decision]

## Consequences
- [what becomes easier or more consistent]
- [what becomes constrained or harder]

## DO NOT
- Do not [action] — [reason]
- Do not [action] — [reason]

## Triggers
Re-evaluate if: [condition that would make this decision obsolete]
```

Maximum 30 lines. Be precise. No filler.

4. Update the decisions index and CLAUDE.md if applicable.
