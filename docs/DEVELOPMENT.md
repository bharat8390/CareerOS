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

## 7. Continuous Integration & Branch Protection
CI is defined in [`.github/workflows/ci.yml`](../.github/workflows/ci.yml) and runs on every PR to `main` and on pushes to `main`. Two parallel jobs:

| Job | Steps |
|-----|-------|
| **Frontend** | `npm ci` → `format:check` → `lint` → `typecheck` → `build` → `test` |
| **Backend** | `pip install -e ".[dev]"` → `ruff check` → `ruff format --check` → `mypy` → `pytest` (coverage uploaded as an artifact) |

Any lint/type/test/build failure fails the run. Coverage is reported but **not gated** yet — a threshold is introduced once domain logic exists (S1-5+).

**Recommended branch-protection rules for `main`** (configure in GitHub → Settings → Branches):
- Require a pull request before merging (no direct pushes to `main`).
- Require status checks to pass: **`Frontend (lint · types · build · test)`** and **`Backend (ruff · mypy · pytest)`**.
- Require branches to be up to date before merging.
- Require at least one approving review; dismiss stale approvals on new commits.
- Do not allow force pushes or deletion of `main`.
