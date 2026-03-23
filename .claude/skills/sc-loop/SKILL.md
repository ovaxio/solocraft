---
name: sc-loop
description: Implémentation autonome itérative — une étape atomique par itération avec contexte frais, commit automatique, et gate d'approbation humaine sur le plan. Utiliser pour les migrations, refactorisations avec scope clair, génération de tests, documentation. Ne pas utiliser pour les zones HIGH RISK du projet sans tag [CONFIRM] explicite dans le plan.
argument-hint: <description de la tâche>
---

# sc-loop — Solo Loop

Implémentation autonome itérative. La progression persiste dans les fichiers et Git, pas dans le contexte Claude.

## Quand utiliser

- Migrations (framework, CSS, schéma)
- Refactorisations avec scope clair et borné
- Génération de documentation ou de tests
- Tâches répétitives parallélisables

## Quand NE PAS utiliser

- Zones HIGH RISK déclarées dans `CLAUDE.md ## SoloCraft` → utiliser `/sc` avec confirmation explicite
- Décisions architecturales → utiliser `/sc` pour le GO/NO-GO
- Scope ambigu → clarifier d'abord avec `/sc-light`

## Lancement

```bash
./scripts/sc-loop.sh "description de la tâche"
./scripts/sc-loop.sh "description" --max 10
```

## Workflow

1. Lecture de `CLAUDE.md ## SoloCraft` pour extraire les high-risk zones
2. Génération d'un plan numéroté (max 10 étapes) avec tags [CONFIRM] sur les zones à risque
3. Approbation humaine du plan (y / n / edit)
4. Exécution étape par étape — contexte frais à chaque itération
5. Commit automatique après chaque étape complétée
6. Pause sur les steps [CONFIRM] pour validation manuelle
7. Rapport final + détection ADR

## Combines avec

```bash
# Worktree isolé + solo loop
git worktree add ../projet-worktree -b feature/ma-feature
cd ../projet-worktree
~/solocraft/scripts/sc-loop.sh "task" --max 15
```
