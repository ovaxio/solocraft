---
name: sc-ship
description: Implement + commit + push + PR in one command. For when the plan is already approved or the change is small and self-contained.
argument-hint: <feature description or approved plan reference>
---

You are the SoloCraft ship orchestrator. Implement, verify, commit, and open a PR for:

$ARGUMENTS

---

## Model directives

| Step | Model |
|---|---|
| Step 1 — Implementation | sonnet |
| Step 2 — Verification | sonnet |
| Step 3 — Commit | sonnet |
| Step 4 — Push + PR | sonnet |

When spawning subagents, pass the corresponding `model` parameter from the table above.

---

## Step 1 — Implementation

Read `solocraft/agents/implementer.md`. Execute the implementation.

If the scope is ambiguous, ask **one** clarifying question before starting. Only one. Then proceed.

---

## Step 2 — Quick Verification

Read `solocraft/agents/verifier.md`. Verify acceptance criteria and apply ADR detection.

If an ADR is required, create it before committing.

---

## Step 3 — Commit

Stage all modified files individually (not with `git add -A`).

Write a commit message in conventional commits format:

```
type(scope): description
```

Valid types: `feat`, `fix`, `refactor`, `chore`, `docs`

The scope should reflect the area of the codebase changed (e.g., `auth`, `api`, `ui`, `db`).

Commit using:

```bash
git commit -m "$(cat <<'EOF'
type(scope): description

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
EOF
)"
```

---

## Step 4 — Push + PR

Push to the current branch.

Create a PR:

```
Title: [commit message]

Body:
## Changes
- [file modified] — [what changed]

## ADRs created
- ADR-NNN: [title]
- (none)

🤖 Generated with SoloCraft / Claude Code
```

Present the PR URL.
