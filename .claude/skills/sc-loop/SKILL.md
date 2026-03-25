---
name: sc-loop
description: Autonomous iterative implementation — plan, loop with auto commits, report. Full auto, zero interaction.
argument-hint: <task description> [--max N]
---

# sc-loop — Solo Loop

Full auto: plan → loop → commit → report. Each iteration has a fresh Claude context.

## Execution

```bash
bash solocraft/scripts/sc-loop.sh "$TASK_DESCRIPTION" $MAX_FLAG
```

Extract `--max N` from `$ARGUMENTS` if present, otherwise default = 25.

## When to use

- Migrations, refactorings with clear scope
- Documentation or test generation
- Repetitive tasks across multiple files

## When NOT to use

- HIGH RISK zones → `/sc`
- Architectural decisions → `/sc`
- Ambiguous scope → `/sc-light`
