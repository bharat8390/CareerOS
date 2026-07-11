# CareerOS

> **AI-Powered Career Intelligence Platform** — helps students become interview-ready,
> track their career journey, and secure offers.

This is the CareerOS **monorepo**. Architecture and product specifications are frozen
in [`docs/`](docs/) (see [`docs/00-README-index.md`](docs/00-README-index.md)); this
repository implements **Version 1 (MVP)** incrementally, one milestone at a time.

> **Current state:** Sprint 1 · Story **S1-1 — Monorepo scaffold + tooling**.
> No application features are implemented yet — this establishes the workspace,
> tooling, and standards that every later story builds on.

## Repository layout

```
careeros/
├─ apps/
│  ├─ web/            # Next.js + TypeScript frontend (shell arrives in S1-6)
│  └─ api/            # FastAPI + Python backend (app factory arrives in S1-3)
├─ packages/
│  ├─ config/         # Shared tooling config (ESLint, tsconfig, Prettier)
│  ├─ contracts/      # Typed API client generated from OpenAPI (S1-7)
│  └─ ui-tokens/      # Design tokens (S1-6)
├─ infra/
│  ├─ docker/         # Service Dockerfiles (S1-8)
│  ├─ compose/        # Docker Compose stacks (S1-8)
│  └─ terraform/      # Infrastructure as code (later)
├─ docs/              # Frozen product & engineering documentation
├─ package.json       # npm workspaces + Turborepo tasks
├─ turbo.json         # Turborepo pipeline
├─ tsconfig.base.json # Strict TypeScript base config
└─ .env.example       # Environment variable contract
```

## Prerequisites

| Tool   | Version                                 | Notes                                    |
| ------ | --------------------------------------- | ---------------------------------------- |
| Node   | `20.18.x` (see `.nvmrc`)                | JS workspaces (`apps/web`, `packages/*`) |
| npm    | `>=10`                                  | Package manager for the JS side          |
| Python | `3.12` (see `apps/api/.python-version`) | Backend (`apps/api`)                     |
| Docker | `>=24`                                  | Local services (from S1-8)               |

## Quick start

```bash
# 1) Copy the environment contract
cp .env.example .env

# 2) JavaScript / TypeScript side
nvm use            # selects Node 20.18.x
npm install        # installs all JS workspaces
npm run lint       # ESLint across workspaces
npm run typecheck  # tsc --noEmit across workspaces
npm run build      # builds apps/web + packages

# 3) Python backend (apps/api)
cd apps/api
python3.12 -m venv .venv && source .venv/bin/activate
pip install -e ".[dev]"
ruff check . && ruff format --check .
mypy .
pytest
```

## Standards & contribution

- Coding standards, branching, commits, and Definition of Done: [`docs/CONTRIBUTING.md`](docs/CONTRIBUTING.md) and [`docs/16-engineering-implementation-plan.md`](docs/16-engineering-implementation-plan.md).
- Architecture (frozen): [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) and [`docs/ADR/`](docs/ADR/).
- Documentation standards: [`docs/DOCUMENTATION-STANDARDS.md`](docs/DOCUMENTATION-STANDARDS.md).

## License

Proprietary — all rights reserved (see repository owner). Not licensed for redistribution.
