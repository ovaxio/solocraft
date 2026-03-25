#!/bin/bash
# Solo Loop — autonomous iterative implementation for SoloCraft
# Full auto: plan → loop → commit → report. No interaction.
# Usage: ./scripts/sc-loop.sh "task description" [--max N]

set -e

# Ensure a recent Node.js for claude CLI (requires Node 18+)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm use stable --silent 2>/dev/null || true

TASK=""
MAX_ITERATIONS=25
PLAN_FILE=".sc-plan.md"
REPORT_FILE=".sc-report.md"
LOG_FILE=".sc-iterations.md"

while [[ "$#" -gt 0 ]]; do
  case $1 in
    --max) MAX_ITERATIONS="$2"; shift 2 ;;
    *) TASK="$1"; shift ;;
  esac
done

if [ -z "$TASK" ]; then
  echo "Usage: ./scripts/sc-loop.sh 'task description' [--max N]"
  exit 1
fi

if ! command -v claude &> /dev/null; then
  echo "ERROR: claude CLI not found"
  exit 1
fi

CLAUDE="claude --print --allowedTools Edit,Write,Read,Glob,Grep,Bash"

# Collect project context
CONTEXT=""
[ -f "CLAUDE.md" ] && CONTEXT="Read CLAUDE.md first."

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║            SOLOCRAFT SOLO LOOP           ║"
echo "╚══════════════════════════════════════════╝"
echo "Task: $TASK"
echo "Max:  $MAX_ITERATIONS"
echo ""

# ── Init log ──────────────────────────────────────────────────────────
echo "# Solo Loop — $TASK" > "$LOG_FILE"
echo "Started: $(date)" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# ── Plan ──────────────────────────────────────────────────────────────
echo "=== Plan ==="

cat <<PROMPT | $CLAUDE > "$PLAN_FILE"
$CONTEXT

Task: $TASK

Generate a numbered implementation plan.
- Each step = one atomic change = one commit
- Format: STEP N: [description]
- Last line: TOTAL: N steps
- No prose.
PROMPT

cat "$PLAN_FILE"
echo ""

TOTAL=$(grep -c "^STEP" "$PLAN_FILE" || echo "0")
echo "→ $TOTAL steps"
echo ""

# ── Set lane to doing ────────────────────────────────────────────────
sed -i '' 's/^lane: planned/lane: doing/' "$PLAN_FILE" 2>/dev/null || true

# ── Loop ──────────────────────────────────────────────────────────────
DONE=0

for i in $(seq 1 "$TOTAL"); do
  [ "$i" -gt "$MAX_ITERATIONS" ] && break

  STEP=$(grep "^STEP $i:" "$PLAN_FILE" | sed "s/^STEP $i: //")
  echo "── Step $i/$TOTAL: $STEP ──"

  cat <<PROMPT | $CLAUDE
$CONTEXT
Read $PLAN_FILE and $LOG_FILE.

Task: $TASK
Execute step $i/$TOTAL: $STEP

Do this step only. Do not touch other steps.
PROMPT

  echo "## Step $i — $STEP" >> "$LOG_FILE"
  echo "Done: $(date)" >> "$LOG_FILE"
  echo "" >> "$LOG_FILE"

  if ! git diff --quiet || ! git diff --staged --quiet; then
    git add -A
    git commit -m "sc-loop($i/$TOTAL): $STEP"
    echo "✓ Committed"
    DONE=$((DONE + 1))
  else
    echo "— No changes"
  fi

  echo ""
done

# ── Set lane to done ──────────────────────────────────────────────────
sed -i '' 's/^lane: doing/lane: done/' "$PLAN_FILE" 2>/dev/null || true

# ── Report ────────────────────────────────────────────────────────────
echo "=== Report ==="

cat <<PROMPT | $CLAUDE > "$REPORT_FILE"
Read $LOG_FILE.
Report for: $TASK
Steps done: $DONE/$TOTAL. Files changed. ADR needed? Markdown, 15 lines max.
PROMPT

cat "$REPORT_FILE"

rm -f "$PLAN_FILE" "$LOG_FILE"
echo ""
echo "Done: $DONE/$TOTAL steps"
