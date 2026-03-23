# Glossaire SoloCraft

Termes clés du framework SoloCraft, par ordre alphabétique.

---

## ADR

**Architecture Decision Record.** Document court qui capture une décision technique, son contexte, les alternatives écartées et les conséquences. Stocké dans le répertoire déclaré sous `decisions-dir` dans CLAUDE.md. Un ADR est créé automatiquement quand le Senior Engineer détecte un changement de comportement non évident, une convention implicite ou un rejet d'approche raisonnable.

---

## Agent

Fichier Markdown dans `agents/` qui définit le rôle, les étapes et le format de sortie d'un spécialiste virtuel. Les agents ne sont jamais exécutés directement — ils sont invoqués par les skills via des subagents. Exemples : `requirement-parser`, `cto-advisor`, `planner`, `code-reviewer`. Chaque agent lit le CLAUDE.md du projet cible pour obtenir son contexte.

---

## CLAUDE.md

Fichier de configuration projet lu automatiquement par Claude Code au démarrage. La section `## SoloCraft` fournit aux agents le contexte nécessaire : stack, target, constraints, high-risk zones et decisions-dir. C'est le seul point d'entrée du contexte projet — aucun agent ne contient de référence à un projet spécifique.

---

## GO/NO-GO

Décision émise par l'agent CTO Advisor en phase 2 du workflow `/sc`. Trois verdicts possibles : **GO** (continuer), **NO-GO** (bloquer avec raison actionnable) ou **GO WITH CONDITIONS** (continuer après validation des conditions par l'utilisateur). Un seul critère NO-GO suffit à bloquer ; tous les critères GO doivent être vrais pour passer.

---

## High-risk zone

Fichier ou composant déclaré dans la section `high-risk-zones` de CLAUDE.md. Toute modification d'une high-risk zone déclenche un flag obligatoire par le Senior Engineer, une étape de confirmation dans le plan, et un tag `[CONFIRM]` en solo loop. Les zones à haut risque de SoloCraft sont : `senior-engineer.md`, `cto-advisor.md` et le SKILL.md de `/sc`.

---

## Phase

Étape séquentielle du workflow `/sc`. Le workflow complet comprend 5 phases : **1 — Research** (3 agents en parallèle), **2 — GO/NO-GO** (décision CTO), **3 — Plan + Approval** (plan atomique soumis à l'utilisateur), **4 — Implementation** (exécution parallèle si possible), **5 — Review + Verification** (code review et validation des critères d'acceptation en parallèle).

---

## Skill

Fichier `SKILL.md` dans `.claude/skills/*/` qui orchestre un workflow complet. Un skill est invocable par l'utilisateur via une commande slash (ex. `/sc`, `/sc-loop`, `/sc-fix`). Il coordonne les agents, gère les gates d'approbation et structure la sortie. Contrairement aux agents, les skills sont le point d'entrée utilisateur.

---

## Solo loop

Mode d'exécution itératif piloté par le script `sc-loop.sh` et le skill `/sc-loop`. Chaque itération utilise un contexte Claude frais, exécute une seule étape atomique, commit automatiquement, et persiste la progression dans des fichiers (`.sc-plan.md`, `.sc-iterations.md`). Conçu pour les tâches à scope clair : migrations, refactorisations, génération de tests ou de documentation. Les étapes touchant des high-risk zones nécessitent un tag `[CONFIRM]` explicite.

---

## Worktree

Copie de travail Git isolée créée via `git worktree add`. Permet d'exécuter un solo loop ou une feature sans toucher à la branche principale. Le worktree partage l'historique Git du repo principal mais possède son propre working directory et sa propre branche. Recommandé pour combiner avec `/sc-loop` sur des tâches longues.
