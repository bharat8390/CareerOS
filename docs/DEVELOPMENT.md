# DEVELOPMENT

> Local setup and day-to-day engineering workflow for CareerOS.
> **Owner:** Lead Engineer · **Last reviewed:** on approval · **Status:** Stable

## 1. Purpose
Get a new engineer from clone → running app → first PR quickly, and codify the workflow (branching, commits, standards, quality gates).

## 2. Contents
- Prerequisites and one-command local bootstrap (Docker Compose).
- Backend/frontend dev commands; migrations; seeding.
- Branching, commit, and PR workflow.
- Coding standards and quality gates (lint/type/test/coverage).
- Troubleshooting.
- **Source of truth:** workflow/standards in [`16-engineering-implementation-plan.md`](16-engineering-implementation-plan.md); process rules in [`CONTRIBUTING.md`](CONTRIBUTING.md).

## 3. Standard Template
```markdown
# DEVELOPMENT
> <one-line dev summary>
## Prerequisites
## Quick Start (Docker)
## Backend Dev
## Frontend Dev
## Database & Migrations
## Seed Data
## Branching & Commits
## Coding Standards
## Quality Gates
## Troubleshooting
```

## 4. Suggested Sections
Prerequisites · Quick start · Backend dev · Frontend dev · DB/migrations · Seed data · Branching/commits · Coding standards · Quality gates · Troubleshooting.

## 5. Best Practices
- One documented path to a running app; keep commands copy-pasteable and current.
- Prefer `make`/`turbo`/scripted tasks over prose so instructions can't drift.
- Every command in this doc is exercised in CI where possible (so stale steps fail fast).
- Link standards; don't restate them.

## 6. Maintenance
- **Owner:** Lead Engineer. **Trigger:** tooling/command/workflow change.
- **Cadence:** as needed; smoke-tested each milestone by a fresh clone.
- **Process:** setup changes update this doc + the environment blueprint in the same PR.
