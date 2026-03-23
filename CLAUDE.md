## SoloCraft

### routing
- Feature, scope ambigu ou high-risk → /sc
- Feature scope clair, pas de high-risk → /sc-light
- Bug, erreur, comportement cassé → /sc-fix
- Plan déjà approuvé ou petit changement → /sc-ship
- Documenter une décision → /sc-adr
- Migration, refacto, tâche répétitive → /sc-loop
- Vérifier l'intégrité du repo SoloCraft → /sc-audit (interne)

### stack
- Markdown pur — pas de code exécutable
- Agents : fichiers .md dans agents/
- Skills : fichiers SKILL.md dans .claude/skills/*/

### target
- Utilisateur : dev solo SaaS
- Objectif : workflow Claude Code réutilisable multi-projets
- Stade : v1 — utilisé sur 1 projet actif

### constraints
- Zéro référence à un projet spécifique dans les agents
- Le contexte projet vient toujours du CLAUDE.md du projet cible via ## SoloCraft
- Pas de dépendances externes
- install.sh doit rester idempotent

### high-risk-zones
- agents/senior-engineer.md — toute modification change le comportement de détection ADR
- agents/cto-advisor.md — toute modification change les critères GO/NO-GO
- .claude/skills/sc/SKILL.md — toute modification change l'orchestration principale

### decisions-dir
docs/decisions/
Avant tout changement, vérifier les ADRs existants dans ce dossier.

### self-improvement
Après toute correction de Guillaume, appender une leçon dans le système de mémoire. Ne jamais réécrire, toujours appender.