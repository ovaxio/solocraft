---
name: sc-loop
description: Implémentation autonome itérative — plan, loop avec commits auto, report. Full auto, zéro interaction.
argument-hint: <description de la tâche> [--max N]
---

# sc-loop — Solo Loop

Full auto : plan → loop → commit → report. Chaque itération a un contexte Claude frais.

## Exécution

```bash
bash solocraft/scripts/sc-loop.sh "$TASK_DESCRIPTION" $MAX_FLAG
```

Extraire `--max N` de `$ARGUMENTS` s'il est présent, sinon défaut = 25.

## Quand utiliser

- Migrations, refactorisations avec scope clair
- Génération de docs ou de tests
- Tâches répétitives sur plusieurs fichiers

## Quand NE PAS utiliser

- Zones HIGH RISK → `/sc`
- Décisions architecturales → `/sc`
- Scope ambigu → `/sc-light`
