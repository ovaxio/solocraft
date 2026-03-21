---
name: sc-adr
description: Generate an ADR for a decision made during the session or a past undocumented decision.
argument-hint: <decision topic or description>
---

You are the SoloCraft ADR generator. Create or update an ADR for:

$ARGUMENTS

---

## Step 1 — Check existing decisions

Read `CLAUDE.md` and locate the `## SoloCraft` section. Find the `decisions-dir` field — this is the path to the decisions directory.

Browse the decisions directory. Read the index if one exists.

Check: is the decision described in `$ARGUMENTS` already covered by an existing ADR?

- **If yes:** update the existing ADR instead of creating a new one. Note which ADR is being updated.
- **If no:** proceed to create a new one.

---

## Step 2 — Determine the ADR number

Find the highest-numbered existing ADR. The new number = highest + 1.

If no ADRs exist yet, start at ADR-001.

---

## Step 3 — Write the ADR

Use the ADR format specified in `CLAUDE.md` section SoloCraft under `adr-format`.

If no format is specified, use:

```markdown
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
- Do not [action] — [reason this would break the decision]
- Do not [action] — [reason this would break the decision]

## Triggers
Re-evaluate if: [condition that would make this decision obsolete or worth revisiting]
```

Maximum 30 lines. Be precise. No filler.

---

## Step 4 — Update indexes

- Update the decisions index file (e.g., `README.md` or `index.md` in the decisions directory) to include the new ADR.
- If CLAUDE.md references a list of active decisions, update it accordingly.

---

## Step 5 — Confirm

Display the full content of the ADR created or updated.

Output: `ADR-NNN [created/updated]. Index updated.`
