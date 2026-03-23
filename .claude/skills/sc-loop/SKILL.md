---
name: sc-loop
description: Implémentation autonome itérative — une étape atomique par itération avec contexte frais, commit automatique, et gate d'approbation humaine sur le plan. Utiliser pour les migrations, refactorisations avec scope clair, génération de tests, documentation. Ne pas utiliser pour les zones HIGH RISK du projet sans tag [CONFIRM] explicite dans le plan.
argument-hint: <description de la tâche> [--max N]
---

# sc-loop — Solo Loop

Implémentation autonome itérative. La progression persiste dans les fichiers et Git, pas dans le contexte Claude.

**Important:** Ce skill DOIT s'exécuter comme script bash car chaque itération nécessite un contexte Claude frais (appels `claude --print` séparés). Ne pas tenter de reproduire le loop dans cette session.

## Exécution

Lance le script Solo Loop avec la commande suivante :

```bash
solocraft/scripts/sc-loop.sh $ARGUMENTS
```

Si `$ARGUMENTS` ne contient pas `--max`, utiliser la valeur par défaut (25 itérations).

Le script est interactif — il demandera :
1. Approbation du plan généré (y/n/edit)
2. Confirmation sur les steps [CONFIRM] touchant des zones HIGH RISK

## Quand utiliser

- Migrations (framework, CSS, schéma)
- Refactorisations avec scope clair et borné
- Génération de documentation ou de tests
- Tâches répétitives parallélisables

## Quand NE PAS utiliser

- Zones HIGH RISK déclarées dans `CLAUDE.md ## SoloCraft` → utiliser `/sc` avec confirmation explicite
- Décisions architecturales → utiliser `/sc` pour le GO/NO-GO
- Scope ambigu → clarifier d'abord avec `/sc-light`

## Combines avec

```bash
# Worktree isolé + solo loop
git worktree add ../projet-worktree -b feature/ma-feature
cd ../projet-worktree
~/solocraft/scripts/sc-loop.sh "task" --max 15
```
