#!/usr/bin/env bash
set -euo pipefail

# SoloCraft installer
# Usage: ./install.sh [target-project-path]
# Default target: current directory

SOLOCRAFT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-$(pwd)}"
TARGET_SKILLS_DIR="$TARGET_DIR/.claude/skills"

SKILLS=(sc sc-light sc-fix sc-ship sc-adr sc-loop)

echo "SoloCraft installer"
echo "  Source:  $SOLOCRAFT_DIR"
echo "  Target:  $TARGET_DIR"
echo ""

# Validate target directory
if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: target directory does not exist: $TARGET_DIR"
  exit 1
fi

# Create .claude/skills if it doesn't exist
if [ ! -d "$TARGET_SKILLS_DIR" ]; then
  mkdir -p "$TARGET_SKILLS_DIR"
  echo "Created $TARGET_SKILLS_DIR"
else
  echo "Found existing $TARGET_SKILLS_DIR — will not overwrite"
fi

echo ""
echo "Installing skills..."

INSTALLED=()
SKIPPED=()

for skill in "${SKILLS[@]}"; do
  SKILL_SOURCE="$SOLOCRAFT_DIR/.claude/skills/$skill"
  SKILL_TARGET="$TARGET_SKILLS_DIR/$skill"

  if [ ! -d "$SKILL_SOURCE" ]; then
    echo "  [SKIP] $skill — source not found at $SKILL_SOURCE"
    SKIPPED+=("$skill (source missing)")
    continue
  fi

  if [ -e "$SKILL_TARGET" ] || [ -L "$SKILL_TARGET" ]; then
    echo "  [SKIP] $skill — already exists at $SKILL_TARGET"
    SKIPPED+=("$skill (already installed)")
    continue
  fi

  ln -s "$SKILL_SOURCE" "$SKILL_TARGET"
  echo "  [OK]   $skill → $SKILL_TARGET"
  INSTALLED+=("$skill")
done

# Link agents root so skills can resolve solocraft/agents/*
SOLOCRAFT_LINK="$TARGET_DIR/solocraft"
if [ -e "$SOLOCRAFT_LINK" ] || [ -L "$SOLOCRAFT_LINK" ]; then
  echo "  [SKIP] solocraft link — already exists"
else
  ln -s "$SOLOCRAFT_DIR" "$SOLOCRAFT_LINK"
  echo "  [OK]   solocraft → $SOLOCRAFT_DIR"
fi

# Add solocraft to .gitignore if not already there
GITIGNORE="$TARGET_DIR/.gitignore"
if [ -f "$GITIGNORE" ]; then
  if ! grep -qx 'solocraft' "$GITIGNORE"; then
    echo 'solocraft' >> "$GITIGNORE"
    echo "  [OK]   added 'solocraft' to .gitignore"
  else
    echo "  [SKIP] 'solocraft' already in .gitignore"
  fi
else
  echo 'solocraft' > "$GITIGNORE"
  echo "  [OK]   created .gitignore with 'solocraft'"
fi

echo ""
echo "Done."
echo ""

if [ ${#INSTALLED[@]} -gt 0 ]; then
  echo "Installed: ${INSTALLED[*]}"
fi

if [ ${#SKIPPED[@]} -gt 0 ]; then
  echo "Skipped:   ${SKIPPED[*]}"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Next step: add the SoloCraft section to your project's CLAUDE.md"
echo ""
echo "  cat $SOLOCRAFT_DIR/solocraft-section.md"
echo ""
echo "Then fill in the placeholders:"
echo "  - stack, target, constraints, high-risk-zones"
echo "  - decisions-dir (e.g. docs/decisions/)"
echo "  - adr-format (optional)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
