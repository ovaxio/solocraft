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

Read `agents/_adr-protocol.md` and follow the creation protocol (format + constraints).

---

## Step 4 — Update indexes

- Update the decisions index file (e.g., `README.md` or `index.md` in the decisions directory) to include the new ADR.
- If CLAUDE.md references a list of active decisions, update it accordingly.

---

## Step 5 — Confirm

Display the full content of the ADR created or updated.

Output: `ADR-NNN [created/updated]. Index updated.`
