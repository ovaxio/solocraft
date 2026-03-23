# SoloCraft section template for CLAUDE.md
# Copy the block below into your project's CLAUDE.md and fill in the placeholders.
# Lines starting with # are comments — remove them after editing.

## SoloCraft

### stack
# List the main technologies, frameworks, and runtimes used in this project.
# Example: Next.js 14 (App Router), TypeScript, Postgres (Supabase), Prisma ORM, Tailwind CSS
[YOUR STACK HERE]

### target
# Describe the product context: who pays, what the revenue model is, and the current stage.
# Example: B2B SaaS targeting solo founders. Monthly subscription. Pre-launch, 3 design partners.
[YOUR TARGET SEGMENT, REVENUE MODEL, AND PRODUCT STAGE HERE]

### constraints
# Non-negotiable rules that apply to this project at all times.
# The CTO Advisor will block any change that violates these.
# Example:
# - No new npm dependencies without explicit approval
# - All DB schema changes require a migration file — never edit schema directly
# - No changes to the billing module without a separate review pass
# - Environment variables must be documented in .env.example
[YOUR NON-NEGOTIABLE CONSTRAINTS HERE]

### high-risk-zones
# Files or modules that require explicit user confirmation before any modification.
# Example:
# - src/lib/auth.ts — handles session tokens, any change can silently break auth
# - prisma/schema.prisma — schema changes cascade to all DB queries
# - src/app/api/webhooks/ — external contract, breaking changes are invisible locally
[YOUR HIGH-RISK FILES AND MODULES HERE, ONE PER LINE WITH A REASON]

### decisions-dir
# Path to the directory where ADRs are stored (relative to project root).
# Example: docs/decisions/
[YOUR DECISIONS DIRECTORY PATH HERE]

### context-modules
# Optional. Map domain names to context files that agents should load when working on that domain.
# This bridges the SoloCraft dispatch layer with your project's domain knowledge.
# Without this, agents can detect risk but cannot evaluate the substance of a change.
# Format: one line per domain — domain-name: path/to/file.md (or comma-separated paths)
# Example:
# - scoring: context/scoring.md, context/lessons.md
# - frontend: context/frontend.md, context/lessons.md
# - billing: context/billing.md
# If absent, agents explore the codebase on their own (default behavior).
[OPTIONAL: YOUR DOMAIN-TO-CONTEXT MAPPINGS HERE, OR DELETE THIS SECTION]

### adr-format
# Optional. Define a custom ADR template if you want something different from the default.
# If this section is absent, sc-adr uses the built-in format.
# Leave blank or remove this section to use the default format.
[OPTIONAL: YOUR ADR TEMPLATE HERE, OR DELETE THIS SECTION]
