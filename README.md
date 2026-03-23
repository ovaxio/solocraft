# SoloCraft

A reusable system of Claude Code agents and skills for solo developers. SoloCraft provides structured, repeatable workflows for feature development, bug fixes, and architectural decisions — without any project-specific assumptions baked in.

**Project context lives in your `CLAUDE.md`**, not in SoloCraft. SoloCraft reads a `## SoloCraft` section from your project's `CLAUDE.md` at runtime to understand your stack, constraints, high-risk zones, and decision history.

---

## Commands

| Command | When to use |
|---|---|
| `/sc <request>` | Full workflow: parallel research, GO/NO-GO decision, plan approval, implementation, review, verification. Use for anything non-trivial or touching high-risk areas. |
| `/sc-light <request>` | Streamlined workflow: analyze, plan, approve, implement, verify. For features where the scope is already clear and no high-risk zones are involved. |
| `/sc-fix <bug>` | Bug diagnosis and fix. Diagnose root cause, apply minimal fix, verify. No plan phase. |
| `/sc-ship <request>` | Implement + commit + push + PR in one command. For approved plans or small self-contained changes. |
| `/sc-adr <decision>` | Document an architectural decision. Creates or updates an ADR and updates the index. |
| `/sc-loop <tâche>` | Implémentation autonome itérative — plan → approbation → loop avec commits auto |
| `/sc-audit` | Audit the SoloCraft repo for structural integrity (agents, skills, install.sh, decisions-dir). Internal maintenance tool — not deployed to target projects. |

---

## Agents

| Agent | Role | Used in |
|---|---|---|
| `requirement-parser` | Transforms a vague request into a structured scope with acceptance criteria | `/sc` phase 1 (parallel) |
| `product-manager` | Evaluates business value, MVP fit, and ROI | `/sc` phase 1 (parallel) |
| `senior-engineer` | Deep technical analysis: files impacted, high-risk zones, ADR detection | `/sc` phase 1 (parallel) |
| `cto-advisor` | Synthesizes phase 1 outputs into a GO / NO-GO / GO WITH CONDITIONS decision | `/sc` phase 2 |
| `planner` | Produces an atomic, ordered implementation plan for user approval | `/sc` phase 3, `/sc-light` step 2 |
| `implementer` | Executes an approved plan step by step, with no improvisation | `/sc` phase 4, `/sc-light` step 3 |
| `snipper` | Fast, targeted edits for small, low-risk changes | `/sc` phase 4 (parallel tasks), `/sc-fix` |
| `code-reviewer` | Reviews implementation against CLAUDE.md constraints and documented decisions | `/sc` phase 5 (parallel) |
| `verifier` | Verifies acceptance criteria, checks regressions, creates flagged ADRs | `/sc` phase 5 (parallel), all other workflows |

---

## Installation

**Step 1 — Clone SoloCraft**

```bash
git clone <solocraft-repo-url> ~/solocraft
```

**Step 2 — Run the installer in your project**

```bash
cd /path/to/your-project
~/solocraft/install.sh
```

This creates symlinks in your project's `.claude/skills/` for each SoloCraft command. It is idempotent — safe to run multiple times.

**Step 3 — Add the SoloCraft section to your CLAUDE.md**

```bash
cat ~/solocraft/solocraft-section.md
```

Copy the `## SoloCraft` block into your project's `CLAUDE.md` and fill in:
- `stack` — your main technologies
- `target` — who pays, revenue model, product stage
- `constraints` — non-negotiable rules
- `high-risk-zones` — files requiring confirmation before modification
- `decisions-dir` — path to your ADR directory (e.g. `docs/decisions/`)
- `adr-format` — optional custom ADR template

---

## Adding project-specific skills or agents

SoloCraft installs individual symlinks per skill — it does not symlink the entire `.claude/skills/` directory. This means you can freely add project-specific skills alongside SoloCraft's commands:

```
your-project/
└── .claude/
    └── skills/
        ├── sc -> ~/solocraft/.claude/skills/sc          # SoloCraft (symlink)
        ├── sc-fix -> ~/solocraft/.claude/skills/sc-fix  # SoloCraft (symlink)
        └── deploy/                                       # Project-specific (yours)
            └── SKILL.md
```

Project-specific agents work the same way — create a `agents/` directory in your project and reference them from your own skills.

---

## Updating SoloCraft

SoloCraft changes propagate automatically via symlinks. To update:

```bash
cd ~/solocraft
git pull
```

No need to re-run the installer unless new skills were added.

If new skills were added:

```bash
~/solocraft/install.sh /path/to/your-project
```

The installer will skip already-installed skills and only add the new ones.

---

## How `/sc` works internally

```
Phase 1 (parallel)    → requirement-parser + product-manager + senior-engineer
Phase 2               → cto-advisor (GO / NO-GO)
Phase 3               → planner → user approval loop
Phase 4 (parallel)    → implementer + snipper (if parallel tasks exist)
Phase 5 (parallel)    → code-reviewer + verifier
```

All context flows forward through the phases. Each agent reads `CLAUDE.md` independently and applies your project's constraints to its output.

---

## Solo Loop

Implémentation autonome itérative pour les tâches avec scope clair.
La progression persiste dans Git — contexte frais à chaque étape.

```bash
./scripts/sc-loop.sh "migrer les composants vers la nouvelle API"
./scripts/sc-loop.sh "générer les tests pour tous les endpoints" --max 10
```

Le loop s'arrête quand : toutes les étapes sont complètes / STATUS:BLOCKED / max iterations atteint.
