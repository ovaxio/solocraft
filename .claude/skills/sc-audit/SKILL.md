---
name: sc-audit
description: Audit the SoloCraft repo for structural integrity — agents, skills, install.sh SKILLS array, and decisions-dir. Read-only. Reports PASS/FAIL per check.
argument-hint: (no arguments needed)
---

> **NON-DEPLOYABLE — INTERNAL SKILL ONLY**
> This skill audits the SoloCraft repository itself. It must NOT be added to the `SKILLS` array in `install.sh` and must NOT be symlinked to target projects. It is only meaningful when invoked from the SoloCraft repo root.

---

You are the SoloCraft audit agent. Your role is to verify the structural integrity of this SoloCraft repository. You are **read-only**: inspect files, report findings, never modify anything.

---

## Step 1 — Locate repo root

Confirm you are running from the SoloCraft repo root by verifying the presence of:
- `install.sh`
- `agents/` directory
- `.claude/skills/` directory
- `README.md`

If any of these are missing, stop and report: `FATAL: Not running from SoloCraft repo root. Aborting audit.`

---

## Step 2 — Run all checks

Execute each check below in sequence. Record the result of each as `PASS` or `FAIL`, with a one-line reason on failure.

---

### Check A — Agent files match README agents table

1. Read `README.md`. Extract every agent name listed in the `## Agents` table (the values in the `Agent` column, without backticks).
2. For each agent name, verify that `agents/<name>.md` exists.
3. Result:
   - `PASS` if every agent listed in the table has a corresponding `.md` file in `agents/`.
   - `FAIL [agent-name missing]` for each agent listed in the table with no corresponding file.

---

### Check B — Every skill directory has a valid SKILL.md

1. List all directories under `.claude/skills/`.
2. For each directory:
   a. Verify that `SKILL.md` exists inside it.
   b. Read the YAML frontmatter (the block between the first two `---` lines).
   c. Verify the frontmatter contains a `name:` field.
   d. Verify the value of `name:` matches the directory name exactly.
3. Result:
   - `PASS` if all skill directories have a `SKILL.md` with a `name:` field matching the directory name.
   - `FAIL [skill-dir: reason]` for each violation found.

---

### Check C — install.sh SKILLS array matches deployable skill directories

1. Read `install.sh`. Extract the `SKILLS=(...)` array value — collect every element listed.
2. List all directories under `.claude/skills/`. For each directory, read its `SKILL.md` and check whether it contains the string `NON-DEPLOYABLE`. Any skill marked `NON-DEPLOYABLE` is intentionally absent from `install.sh` — exclude it from the comparison.
3. Compare the two sets (deployable skills only):
   - Every deployable skill directory should appear in the `SKILLS` array.
   - Every entry in the `SKILLS` array should have a corresponding directory under `.claude/skills/`.
4. Result:
   - `PASS` if the two sets are identical.
   - `FAIL [missing from SKILLS: ...]` if a deployable skill directory is not listed in `install.sh`.
   - `FAIL [in SKILLS but no directory: ...]` if an entry in `SKILLS` has no corresponding directory.

---

### Check D — No agent file contains project-specific references

1. Read every `.md` file in `agents/`.
2. For each file, check for the presence of:
   - Hardcoded absolute paths (patterns like `/Users/`, `/home/`, `/var/`, `C:\`)
   - Any proper noun that appears to be a company name, product name, or specific project name (evaluate contextually — generic terms like "your project", "the project", "project name" are fine)
3. Result:
   - `PASS` if no agent file contains hardcoded paths or project-specific proper nouns.
   - `FAIL [file: reason]` for each violation found.

---

### Check E — docs/decisions/ directory exists

1. Check whether the directory `docs/decisions/` exists at the repo root.
2. This directory is declared as `decisions-dir` in `CLAUDE.md` and must be present.
3. Result:
   - `PASS` if `docs/decisions/` exists.
   - `FAIL` if `docs/decisions/` does not exist.

---

### Check F — CLAUDE.md contains ## SoloCraft section

1. Read `CLAUDE.md` at the repo root.
2. Verify the file contains a `## SoloCraft` heading.
3. This section is the mandatory entry point for project context used by all SoloCraft agents — its absence would silently break every skill on a target project.
4. Result:
   - `PASS` if `## SoloCraft` heading is present in `CLAUDE.md`.
   - `FAIL` if `CLAUDE.md` is missing or does not contain `## SoloCraft`.

---

## Step 3 — Output the audit report

Produce a structured report in the following format:

```
## SoloCraft Audit Report

| Check | Description                                          | Result |
|-------|------------------------------------------------------|--------|
| A     | Agent files match README agents table                | PASS / FAIL |
| B     | Every skill directory has a valid SKILL.md           | PASS / FAIL |
| C     | install.sh SKILLS array matches skill directories    | PASS / FAIL |
| D     | No agent file contains project-specific references   | PASS / FAIL |
| E     | docs/decisions/ directory exists                     | PASS / FAIL |
| F     | CLAUDE.md contains ## SoloCraft section              | PASS / FAIL |

### Summary
- Checks passed: X / 6
- Checks failed: Y / 6

### Failure details
[For each FAIL, list the specific violations found. Omit this section if all checks passed.]
```

If all 6 checks pass, append: `All checks passed. SoloCraft repo is structurally sound.`

If any check fails, append: `Action required. Fix the failures listed above before deploying or distributing SoloCraft.`
