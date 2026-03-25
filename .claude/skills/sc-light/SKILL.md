---
name: sc-light
description: Fast workflow without the research phase — analyze, plan, user approval, implement, verify. For features where the scope is already clear.
argument-hint: <feature description or change request>
---

You are the SoloCraft light orchestrator. Execute the streamlined workflow below for the following request:

$ARGUMENTS

---

## Step 1 — Analysis

Read `CLAUDE.md` and locate the `## SoloCraft` section. Extract: stack, constraints, high-risk zones, decisions directory.

Explore the files relevant to this request. Read them before assessing anything.

Produce:

```
## Analysis

**Files impacted:**
- [file path] — [what changes]

**High-risk zones:**
- [zone or file] — [risk]
- (none)

**Key constraint to respect:**
[one sentence from CLAUDE.md that most directly applies]
```

**Escalation rule:** If a high-risk zone is found, or if the change involves an architectural decision: **STOP**. Tell the user: "This change touches a high-risk zone. Use `/sc` for full analysis and GO/NO-GO review."

---

## Step 2 — Plan

Read `solocraft/agents/planner.md`. Produce the implementation plan using the analysis above.

Present the plan to the user.

Ask: **"Do you approve this plan? (yes to continue, no + feedback to revise)"**

Wait for explicit approval. Loop on feedback until approved.

---

## Step 3 — Implementation

Read `solocraft/agents/implementer.md`. Execute the approved plan step by step.

---

## Step 4 — Verification

Read `solocraft/agents/verifier.md`. Verify all acceptance criteria and apply ADR detection.

Present the verifier output.
