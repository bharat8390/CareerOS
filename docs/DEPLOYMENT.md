# DEPLOYMENT

> Environments, CI/CD, and release operations for CareerOS.
> **Owner:** DevOps · **Last reviewed:** on approval · **Status:** Stable

## 1. Purpose
Describe how CareerOS is built, containerized, deployed, and operated across environments, and the env-var contract required to run it.

## 2. Contents
- Environment matrix (local / preview / staging / production).
- Container images and Docker Compose (local) topology.
- CI/CD pipeline stages and gates.
- Environment-variable contract and secret management.
- Observability, backups/DR, and rollout/rollback strategy.
- **Source of truth:** [`13-deployment.md`](13-deployment.md).

## 3. Standard Template
```markdown
# DEPLOYMENT
> <one-line deploy summary>
## Environments
## Container Images
## Local (Docker Compose)
## CI/CD Pipeline
## Environment Variables
## Secrets Management
## Observability
## Backups & DR
## Rollout & Rollback
```

## 4. Suggested Sections
Environments · Container images · Local compose · CI/CD pipeline · Env vars · Secrets · Observability · Backups/DR · Rollout/rollback.

## 5. Best Practices
- One image per service, built once and promoted across environments (no rebuild per env).
- Secrets never in the repo; injected per environment; `.env.example` documents the contract.
- Migrations gated in the deploy pipeline; support forward-only + rollback plan.
- Prefer blue-green / preview environments; every PR gets a preview deploy.

## 6. Maintenance
- **Owner:** DevOps. **Trigger:** infra/pipeline/env-var change.
- **Cadence:** reviewed per release; DR drill validated before GA.
- **Process:** pipeline changes update this doc + workflow files together; new env vars update `.env.example`.
