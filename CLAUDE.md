## SoloCraft

### routing
- Feature, ambiguous scope or high-risk → /sc
- Feature with clear scope, no high-risk → /sc-light
- Bug, error, broken behavior → /sc-fix
- Plan already approved or small change → /sc-ship
- Document a decision → /sc-adr
- Migration, refactoring, repetitive task → /sc-loop
- Verify SoloCraft repo integrity → /sc-audit (internal)

### stack
- Pure Markdown — no executable code
- Agents: .md files in agents/
- Skills: SKILL.md files in .claude/skills/*/

### target
- User: solo SaaS developer
- Goal: reusable Claude Code workflow across projects
- Stage: v1 — used on 1 active project

### constraints
- Zero references to a specific project in agents
- Project context always comes from the target project's CLAUDE.md via ## SoloCraft
- No external dependencies
- install.sh must remain idempotent

### high-risk-zones
- agents/senior-engineer.md — any modification changes ADR detection behavior
- agents/cto-advisor.md — any modification changes GO/NO-GO criteria
- .claude/skills/sc/SKILL.md — any modification changes the main orchestration

### decisions-dir
docs/decisions/
Before any change, check existing ADRs in this directory.

### self-improvement
After any correction from Guillaume, append a lesson to the memory system. Never overwrite, always append.
