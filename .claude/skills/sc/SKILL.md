---
name: sc
description: Full SoloCraft workflow — parallel research, GO/NO-GO decision, plan, user approval, implementation, review, and verification.
argument-hint: <feature description or change request>
---

You are the SoloCraft orchestrator. Execute the full workflow below for the following request:

$ARGUMENTS

---

## Model directives

| Phase | Model |
|---|---|
| Phase 1 — Research (subagents) | sonnet |
| Phase 2 — GO/NO-GO | opus |
| Phase 3 — Plan + Approval | sonnet |
| Phase 4 — Implementation (subagents) | sonnet |
| Phase 5 — Review + Verification (subagents) | sonnet |

When spawning subagents, pass the corresponding `model` parameter from the table above. Phase 2 (GO/NO-GO) uses `model: "opus"` for deeper reasoning on critical decisions.

---

## Phase 1 — Research (parallel)

Spawn 3 subagents in parallel using the Task tool. Do not wait for one to finish before starting the others.

- **Subagent 1:** Read `solocraft/agents/requirement-parser.md` and execute its instructions for the request above.
- **Subagent 2:** Read `solocraft/agents/product-manager.md` and execute its instructions for the request above.
- **Subagent 3:** Read `solocraft/agents/senior-engineer.md` and execute its instructions for the request above.

Wait for all 3 to complete before proceeding.

---

## Phase 2 — GO/NO-GO

Read `solocraft/agents/cto-advisor.md`. Execute its instructions using the 3 outputs from phase 1 as inputs.

Present the decision to the user.

- If **NO-GO**: display the blocking reason and what would change the decision. **Stop here.**
- If **GO WITH CONDITIONS**: display the conditions and ask the user to confirm before continuing. Do not proceed until confirmed.
- If **GO**: continue to phase 3.

---

## Phase 3 — Plan + Approval

Read `solocraft/agents/planner.md`. Execute its instructions using all phase 1 and phase 2 outputs as inputs.

Present the full plan to the user.

Ask: **"Do you approve this plan? (yes to continue, no + feedback to revise)"**

Wait for explicit approval. If the user provides feedback, revise the plan and ask again. Loop until the user approves.

---

## Phase 4 — Implementation (parallel where possible)

Read `solocraft/agents/implementer.md`. Spawn an implementer subagent to execute the approved plan.

If the plan identifies parallel tasks (independent files or concerns): also spawn a snipper subagent using `solocraft/agents/snipper.md` to handle those tasks concurrently.

Wait for all implementation subagents to complete before proceeding.

---

## Phase 5 — Review + Verification (parallel)

Spawn 2 subagents in parallel:

- **Subagent 1:** Read `solocraft/agents/code-reviewer.md` and review the implementation.
- **Subagent 2:** Read `solocraft/agents/verifier.md` and verify acceptance criteria and create any required ADRs.

Wait for both to complete.

---

## Completion

Present a final summary:

```
## SoloCraft Complete

**Implemented:** [one sentence describing what was built]

**Files modified:**
- [file path]

**ADRs created:**
- ADR-NNN: [title]
- (none)

**Open issues:**
- [BLOCKER / WARNING from code-reviewer]
- (none)
```
