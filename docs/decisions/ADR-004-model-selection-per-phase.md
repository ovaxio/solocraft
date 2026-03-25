# ADR-004: Model selection per workflow phase

**Date:** 2026-03-25
**Status:** Accepted

## Decision
Each SoloCraft skill specifies a model directive per phase. GO/NO-GO uses opus for deeper reasoning; research search subagents use haiku for speed; all other phases use sonnet as the default.

## Rationale
- Critical decisions (GO/NO-GO) benefit from stronger reasoning — opus is the right trade-off
- Search subagents in sc-research are simple web queries — haiku is faster and cheaper
- Sonnet covers the middle ground for planning, implementation, and review
- Skills are pure markdown — directives are soft instructions, not enforced by code

## Consequences
- Better cost/speed balance across workflows
- Model selection is probabilistic (LLM instruction-following), not deterministic
- Each skill file now has a model directives section to maintain

## DO NOT
- Do not hardcode model names in agent .md files — model directives live in skill SKILL.md files only
- Do not assume directives are always followed — they are prompt-based hints

## Triggers
Re-evaluate if: Claude Code adds a deterministic model override mechanism for skills, or if new models change the cost/quality trade-offs.
