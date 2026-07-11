# Contributing to CareerOS

The full contribution guide — branching model, Conventional Commits, PR process,
review checklist, coding standards, and Definition of Done — lives in the docs set:

- **[docs/CONTRIBUTING.md](docs/CONTRIBUTING.md)** — process and workflow.
- **[docs/16-engineering-implementation-plan.md](docs/16-engineering-implementation-plan.md)** — branching (§6), commits (§7), coding standards (§8), folder structure (§9).
- **[docs/DOCUMENTATION-STANDARDS.md](docs/DOCUMENTATION-STANDARDS.md)** — documentation conventions.

Quick rules:

- Trunk-based development; short-lived `feat/*`, `fix/*`, `chore/*` branches; squash-merge into `main`.
- [Conventional Commits](https://www.conventionalcommits.org/): `type(scope): summary`.
- One PR per story; tests and docs ship with the code that needs them.
- Lint, typecheck, and tests must pass before merge.
