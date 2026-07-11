# CONTRIBUTING

> How to contribute to CareerOS: workflow, standards, and review expectations.
> **Owner:** Lead Engineer · **Last reviewed:** on approval · **Status:** Stable

## 1. Purpose
Set the rules of the road for changes so contributions are consistent, reviewable, and safe — even with a single contributor scaling to a team.

## 2. Contents
- Branching model and naming.
- Conventional Commits and commit hygiene.
- PR process, size, and review checklist.
- Coding standards and required local checks.
- Definition of Done and merge requirements.
- Issue/PR templates and CODEOWNERS.
- **Source of truth:** [`16-engineering-implementation-plan.md`](16-engineering-implementation-plan.md) §§6–9.

## 3. Standard Template
```markdown
# CONTRIBUTING
> <one-line contribution summary>
## Code of Conduct (link)
## Branching Model
## Commit Convention
## Pull Request Process
## PR Review Checklist
## Coding Standards
## Local Checks (lint/type/test)
## Definition of Done
## Issue & PR Templates
## CODEOWNERS
```

## 4. Suggested Sections
Code of conduct · Branching · Commits · PR process · Review checklist · Coding standards · Local checks · Definition of Done · Templates · CODEOWNERS.

## 5. Best Practices
- Small, focused PRs mapped to one backlog story; squash-merge to keep `main` linear.
- Conventional Commits (`feat(scope): …`); no "wip"/"fix stuff".
- Docs + tests ship in the **same PR** as the behavior they describe.
- Reviews check correctness, tests, security, and doc updates — not style (tools enforce style).

## 6. Maintenance
- **Owner:** Lead Engineer. **Trigger:** process/tooling change.
- **Cadence:** as needed; confirmed each version cut.
- **Process:** changes here update the PR/issue templates and CI checks together.
