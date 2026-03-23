#!/bin/bash
# Solo Loop — autonomous iterative implementation for SoloCraft
# Principle: progress in files and Git, not in AI context
# Usage: ./scripts/sc-loop.sh "task description" [--max N] [--yes]

set -e

# Ensure a recent Node.js for claude CLI (requires Node 18+)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm use stable --silent 2>/dev/null || true

TASK=""
MAX_ITERATIONS=25
AUTO_APPROVE=0
PLAN_FILE=".sc-plan.md"
REPORT_FILE=".sc-report.md"
ITERATION_LOG=".sc-iterations.md"

while [[ "$#" -gt 0 ]]; do
  case $1 in
    --max) MAX_ITERATIONS="$2"; shift 2 ;;
    --yes) AUTO_APPROVE=1; shift ;;
    *) TASK="$1"; shift ;;
  esac
done

if [ -z "$TASK" ]; then
  echo "Usage: ./scripts/sc-loop.sh 'task description' [--max N]"
  exit 1
fi

if ! command -v claude &> /dev/null; then
  echo "ERROR: claude CLI not found. Install: npm install -g @anthropic-ai/claude-code"
  exit 1
fi

# Claude CLI flags for non-interactive subprocess calls
CLAUDE_OPTS="--allowedTools Edit,Write,Read,Glob,Grep,Bash"

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║            SOLOCRAFT SOLO LOOP           ║"
echo "╚══════════════════════════════════════════╝"
echo "Task:           $TASK"
echo "Max iterations: $MAX_ITERATIONS"
[ $AUTO_APPROVE -eq 1 ] && echo "Mode:           auto-approve (--yes)"
echo ""

# Collect context files
CONTEXT_FILES=""
[ -f "CLAUDE.md" ] && CONTEXT_FILES="CLAUDE.md"
[ -f "docs/decisions/README.md" ] && CONTEXT_FILES="$CONTEXT_FILES docs/decisions/README.md"

# Extract high-risk zones from CLAUDE.md ## SoloCraft if present
HIGH_RISK_ZONES=""
if [ -f "CLAUDE.md" ]; then
  HIGH_RISK_ZONES=$(awk '/^### high-risk-zones/,/^###/' CLAUDE.md \
    | grep -v "^###" | grep -v "^$" | head -10 || true)
fi

# Init iteration log
echo "# Solo Loop — $TASK" > "$ITERATION_LOG"
echo "Started: $(date)" >> "$ITERATION_LOG"
echo "" >> "$ITERATION_LOG"

# ── PHASE 1: Generate plan ──────────────────────────────────────────

echo "=== Generating plan ==="

cat <<PROMPT | claude --print $CLAUDE_OPTS > "$PLAN_FILE"
$([ -n "$CONTEXT_FILES" ] && echo "Read these files first: $CONTEXT_FILES")

Task: $TASK

$([ -n "$HIGH_RISK_ZONES" ] && echo "HIGH RISK zones in this project (require [CONFIRM] tag):
$HIGH_RISK_ZONES")

Generate a numbered implementation plan. Rules:
- Max 10 steps
- Each step must be atomic and completable in one Claude session
- Each step must produce a committable change
- Any step touching a HIGH RISK zone listed above must have a [CONFIRM] tag
- Format exactly:
  STEP 1: [description] [CONFIRM?]
  STEP 2: [description]
  ...
  TOTAL: N steps

Output the plan only. No prose. No explanation.
PROMPT

echo ""
cat "$PLAN_FILE"
echo ""

# ── PHASE 2: Human approval gate ───────────────────────────────────

if [ $AUTO_APPROVE -eq 1 ]; then
  echo "Plan auto-approved (--yes)."
else
  read -p "Approve this plan? (y/n/edit) " APPROVAL

  case $APPROVAL in
    y|Y)
      echo "Plan approved."
      ;;
    edit)
      ${EDITOR:-nano} "$PLAN_FILE"
      echo "Plan after edit:"
      cat "$PLAN_FILE"
      read -p "Confirm edited plan? (y/n) " CONFIRM
      if [ "$CONFIRM" != "y" ]; then
        echo "Aborted."
        rm -f "$PLAN_FILE" "$ITERATION_LOG"
        exit 0
      fi
      ;;
    *)
      echo "Plan rejected. Exiting."
      rm -f "$PLAN_FILE" "$ITERATION_LOG"
      exit 0
      ;;
  esac
fi

TOTAL_STEPS=$(grep -c "^STEP" "$PLAN_FILE" || echo "0")
echo ""
echo "Executing $TOTAL_STEPS steps..."

# ── PHASE 3: Execute loop ───────────────────────────────────────────

COMPLETED=0
BLOCKED=0

for i in $(seq 1 $MAX_ITERATIONS); do

  if [ $i -gt $TOTAL_STEPS ]; then
    echo ""
    echo "All $TOTAL_STEPS steps completed."
    break
  fi

  CURRENT_STEP=$(grep "^STEP $i:" "$PLAN_FILE" | sed "s/^STEP $i: //")
  REQUIRES_CONFIRM=$(echo "$CURRENT_STEP" | grep -c "\[CONFIRM\]" || true)

  echo ""
  echo "──────────────────────────────────────────"
  echo "Iteration $i/$TOTAL_STEPS"
  echo "Step: $CURRENT_STEP"
  echo "──────────────────────────────────────────"

  if [ "$REQUIRES_CONFIRM" -gt 0 ]; then
    if [ $AUTO_APPROVE -eq 1 ]; then
      echo "⚠  HIGH RISK ZONE — step $i skipped in auto mode ([CONFIRM] tag)"
      echo "## Step $i — SKIPPED (auto mode, [CONFIRM])" >> "$ITERATION_LOG"
      continue
    fi
    echo ""
    echo "⚠  HIGH RISK ZONE — confirmation requise ([CONFIRM] tag)"
    read -p "Exécuter cette étape ? (y/n) " STEP_CONFIRM
    if [ "$STEP_CONFIRM" != "y" ]; then
      echo "Step $i skipped."
      echo "## Step $i — SKIPPED by user" >> "$ITERATION_LOG"
      continue
    fi
  fi

  cat <<PROMPT | claude --print $CLAUDE_OPTS
$([ -n "$CONTEXT_FILES" ] && echo "Read these files first: $CONTEXT_FILES")
Read $PLAN_FILE for full task context.
Read $ITERATION_LOG for completed steps.

Current task: $TASK
Current step ($i/$TOTAL_STEPS): $CURRENT_STEP

$([ -n "$HIGH_RISK_ZONES" ] && echo "HIGH RISK zones — never touch without [CONFIRM] tag:
$HIGH_RISK_ZONES")

Execute this step only. Show diffs. Do not execute other steps.
After completing, output exactly one of:
  STATUS:DONE
  STATUS:BLOCKED:[reason]
PROMPT

  echo "## Step $i — $CURRENT_STEP" >> "$ITERATION_LOG"
  echo "Executed: $(date)" >> "$ITERATION_LOG"
  echo "" >> "$ITERATION_LOG"

  if ! git diff --quiet || ! git diff --staged --quiet; then
    git add -A
    git commit -m "sc-loop($i/$TOTAL_STEPS): $CURRENT_STEP"
    echo "✓ Committed step $i"
    COMPLETED=$((COMPLETED + 1))
  else
    echo "No changes at step $i"
  fi

done

# ── PHASE 4: Final report ───────────────────────────────────────────

echo ""
echo "=== Generating final report ==="

cat <<PROMPT | claude --print $CLAUDE_OPTS > "$REPORT_FILE"
Read $ITERATION_LOG.

Generate a completion report for: $TASK
Include:
- Steps completed ($COMPLETED/$TOTAL_STEPS)
- Files changed (git log --name-only -$COMPLETED)
- Remaining TODOs if any
- ADR needed? YES/NO — reason (use criteria from CLAUDE.md if present)

Markdown. Max 20 lines.
PROMPT

rm -f "$PLAN_FILE" "$ITERATION_LOG"

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║          SOLO LOOP COMPLETE              ║"
echo "╚══════════════════════════════════════════╝"
cat "$REPORT_FILE"
echo ""
echo "Report saved: $REPORT_FILE"
echo "Completed: $COMPLETED/$TOTAL_STEPS steps"
[ $BLOCKED -eq 1 ] && echo "Status: BLOCKED — intervention manuelle requise"
[ $BLOCKED -eq 0 ] && echo "Status: COMPLETE"
