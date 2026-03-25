# SoloCraft Glossary

Key terms of the SoloCraft framework, in alphabetical order.

---

## ADR

**Architecture Decision Record.** Short document that captures a technical decision, its context, rejected alternatives, and consequences. Stored in the directory declared under `decisions-dir` in CLAUDE.md. An ADR is created automatically when the Senior Engineer detects a non-obvious behavior change, an implicit convention, or a rejection of a reasonable approach.

---

## Agent

Markdown file in `agents/` that defines the role, steps, and output format of a virtual specialist. Agents are never executed directly — they are invoked by skills via subagents. Examples: `requirement-parser`, `cto-advisor`, `planner`, `code-reviewer`. Each agent reads the target project's CLAUDE.md for context.

---

## CLAUDE.md

Project configuration file automatically read by Claude Code at startup. The `## SoloCraft` section provides agents with the necessary context: stack, target, constraints, high-risk zones, and decisions-dir. It is the sole entry point for project context — no agent contains references to a specific project.

---

## GO/NO-GO

Decision issued by the CTO Advisor agent in phase 2 of the `/sc` workflow. Three possible verdicts: **GO** (proceed), **NO-GO** (block with actionable reason), or **GO WITH CONDITIONS** (proceed after user validates the conditions). A single NO-GO criterion is enough to block; all GO criteria must be true to proceed.

---

## High-risk zone

File or component declared in the `high-risk-zones` section of CLAUDE.md. Any modification to a high-risk zone triggers a mandatory flag by the Senior Engineer, a confirmation step in the plan, and a `[CONFIRM]` tag in solo loop. SoloCraft's own high-risk zones are: `senior-engineer.md`, `cto-advisor.md`, and the `/sc` SKILL.md.

---

## Phase

Sequential step of the `/sc` workflow. The full workflow comprises 5 phases: **1 — Research** (3 agents in parallel), **2 — GO/NO-GO** (CTO decision), **3 — Plan + Approval** (atomic plan submitted to the user), **4 — Implementation** (parallel execution when possible), **5 — Review + Verification** (code review and acceptance criteria validation in parallel).

---

## Skill

`SKILL.md` file in `.claude/skills/*/` that orchestrates a complete workflow. A skill is user-invocable via a slash command (e.g., `/sc`, `/sc-loop`, `/sc-fix`). It coordinates agents, manages approval gates, and structures the output. Unlike agents, skills are the user entry point.

---

## Solo loop

Iterative execution mode driven by the `sc-loop.sh` script and the `/sc-loop` skill. Each iteration uses a fresh Claude context, executes a single atomic step, auto-commits, and persists progress in files (`.sc-plan.md`, `.sc-iterations.md`). Designed for tasks with clear scope: migrations, refactorings, test or documentation generation. Steps touching high-risk zones require an explicit `[CONFIRM]` tag.

---

## Worktree

Isolated Git working copy created via `git worktree add`. Allows running a solo loop or a feature without touching the main branch. The worktree shares Git history with the main repo but has its own working directory and branch. Recommended for combining with `/sc-loop` on long-running tasks.
