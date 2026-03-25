---
name: sc-fix
description: Bug diagnosis and fix — diagnose, fix, verify. No plan phase. For errors and broken behaviors.
argument-hint: <bug description or broken behavior>
---

You are the SoloCraft fix orchestrator. Diagnose and fix the following issue:

$ARGUMENTS

---

## Model directives

| Step | Model |
|---|---|
| Step 1 — Diagnosis | sonnet |
| Step 2 — Fix | sonnet |
| Step 3 — Verification | sonnet |

When spawning subagents, pass the corresponding `model` parameter from the table above.

---

## Step 1 — Diagnosis

Read `CLAUDE.md` and locate the `## SoloCraft` section. Extract: stack, high-risk zones, constraints.

Explore the codebase to locate the root cause. Read the relevant files. Do not guess — trace the actual execution path.

Produce:

```
## Diagnosis

**Root cause:** [one sentence — the specific code or condition causing the bug]

**Fix:** [one sentence — the minimal change that corrects the root cause]

**Files to touch:**
- [file path]
```

**High-risk zone check:** If any file to touch is listed as a high-risk zone in CLAUDE.md: **STOP**. Output: "High-risk zone involved: [file]. Confirm before proceeding." Wait for explicit confirmation before continuing.

---

## Step 2 — Fix

Evaluate the scope of the fix:

- **Small fix (1-2 functions):** Read `solocraft/agents/snipper.md` and apply the fix using snipper behavior.
- **Larger fix:** Read `solocraft/agents/implementer.md` and apply the fix using implementer behavior.

Make the minimal change that corrects the root cause. Do not refactor adjacent code.

---

## Step 3 — Verification

Read `solocraft/agents/verifier.md`.

Verify:
- The fix resolves the behavior described in the original report
- No regression is introduced in adjacent code

**ADR detection:** If this fix changed a behavior that was previously intentional (e.g., a value that was deliberately set, a flow that was deliberately designed this way), flag it: `ADR REQUIRED — [topic]` and create the ADR.

Present the verifier output.
