# 02 — Software Architecture

> Diagrams use **Mermaid** so they render in GitHub/most Markdown viewers.

## 2.1 Architectural principles

1. **Modular monolith first, microservices-ready.** One deployable API composed of clearly bounded modules with explicit interfaces. Boundaries are drawn so that AI, Analytics, Notifications, and Integrations can be extracted later without rewrites.
2. **Layered & dependency-directed.** Presentation → API → Business (domain services) → Data. Dependencies point inward; the domain layer never imports web/ORM specifics directly (repository interfaces isolate persistence).
3. **API-first.** Every capability is exposed through a versioned REST API documented via OpenAPI. The web client is just the first consumer (mobile later).
4. **Async by default for heavy work.** AI calls, third-party sync, notifications, PDF generation, and analytics rollups run on background workers.
5. **Stateless services.** No in-process session state; horizontal scale behind a load balancer. State lives in Postgres/Redis/object storage.
6. **Event-oriented internals.** Domain events (`application.status_changed`, `topic.mastered`, `problem.solved`) trigger score recomputation, notifications, and analytics — decoupling producers from consumers.
7. **Secure & observable by construction.** RBAC, input validation, encryption, structured logging, metrics, tracing, and audit trails are cross-cutting concerns, not afterthoughts.

---

## 2.2 High-level system diagram

```mermaid
flowchart TB
  subgraph Client["Client Tier"]
    WEB["Web App (Next.js + React/TS)"]
    MOB["Mobile (future, same API)"]
  end

  CDN["CDN / Static Assets"]
  LB["API Gateway / Load Balancer<br/>(TLS, routing, rate limit)"]

  subgraph App["Application Tier (stateless, horizontally scaled)"]
    API["FastAPI Backend<br/>(REST API + Business Layer)"]
    AUTH["Auth Service/Module<br/>(JWT, OAuth2, 2FA)"]
    AIGW["AI Gateway Service<br/>(prompts, cache, provider routing)"]
    WORK["Async Workers (Celery)<br/>jobs: sync, notify, score, PDF, AI"]
    SCHED["Scheduler (Celery Beat)<br/>reminders, rollups, revision"]
  end

  subgraph Data["Data Tier"]
    PG[("PostgreSQL 16<br/>+ pgvector")]
    REDIS[("Redis<br/>cache / broker / rate-limit")]
    OBJ[("S3-compatible<br/>Object Storage")]
  end

  subgraph External["External / Third-Party"]
    LLM["LLM Provider"]
    GH["GitHub API"]
    LI["LinkedIn (limited)"]
    MAIL["Email Provider"]
    OAUTHP["OAuth Providers<br/>(Google/GitHub)"]
  end

  WEB --> CDN
  WEB --> LB
  MOB --> LB
  LB --> API
  API --> AUTH
  API --> AIGW
  API --> PG
  API --> REDIS
  API --> OBJ
  API -- enqueue --> REDIS
  WORK --> REDIS
  SCHED --> REDIS
  WORK --> PG
  WORK --> OBJ
  AIGW --> LLM
  AIGW --> PG
  WORK --> GH
  WORK --> LI
  WORK --> MAIL
  AUTH --> OAUTHP
```

---

## 2.3 Layered (logical) architecture

```mermaid
flowchart TB
  P["Presentation Layer<br/>Next.js pages, components, client state, charts"]
  A["API Layer<br/>FastAPI routers, request/response schemas (Pydantic),<br/>authN/Z middleware, validation, rate limiting, error mapping"]
  B["Business / Domain Layer<br/>Module services, domain models, rules,<br/>Career Readiness Index engine, domain events"]
  AN["Analytics Layer<br/>KPI computation, rollups, funnels, trends"]
  AI["AI Layer<br/>AI Gateway, prompt templates, RAG (pgvector), guardrails"]
  N["Notification Layer<br/>channel adapters (in-app/email/push), preferences, templating"]
  D["Data Access Layer<br/>Repositories, SQLAlchemy models, migrations, caching"]
  P --> A --> B
  B --> AN
  B --> AI
  B --> N
  B --> D
  AN --> D
  AI --> D
  N --> D
```

### Layer responsibilities

**Frontend (Presentation).** Next.js app router; server components for data-heavy pages; client components for interactivity. Server-state via TanStack Query (caching, optimistic updates); light UI state via Zustand. Design system with Tailwind + shadcn/ui. Charts via Recharts/D3. Auth tokens in httpOnly cookies; all data via the REST API.

**Backend (API Layer).** FastAPI routers grouped by module, each versioned under `/api/v1`. Responsibilities: authentication/authorization middleware, request validation (Pydantic), response serialization, pagination/filtering, rate limiting, consistent error envelope, OpenAPI generation. No business logic here — routers delegate to services.

**Authentication.** JWT access (short-lived) + refresh (rotating, httpOnly cookie). OAuth2 (Google/GitHub). Optional TOTP 2FA. Argon2 password hashing. Issues/validates tokens, manages sessions/refresh rotation, enforces RBAC scopes. (Details in doc 11.)

**Database.** PostgreSQL as system of record; JSONB for flexible/semi-structured fields (e.g., resume section content, KPI blobs); pgvector for embeddings. Alembic migrations. Read replicas added under load.

**API Layer** (as above) — the contract boundary; see doc 05 for the full contract.

**Business Layer.** The heart: one service module per domain (Learning, Coding, Projects, Resume, GitHub, LinkedIn, Company, Application, Interview, Sprint, Goals, Achievements). Encapsulates rules and orchestrates repositories. Hosts the **Career Readiness Index engine** and emits **domain events**.

**Analytics Layer.** Consumes domain events and scheduled rollups to compute KPIs (streaks, coverage, funnel conversion, CRI sub-scores). Writes denormalized `analytics_snapshots` for fast dashboard reads; heavy aggregation runs in workers.

**Notification Layer.** Preference-aware dispatch across channels (in-app, email now; push later). Template engine; deduplication; quiet hours; delivery status tracking. Triggered by events and the scheduler (deadlines, revision, sprint reminders).

**AI Layer.** An **AI Gateway** service centralizes all LLM access: prompt templates, context assembly (RAG over user data via pgvector), provider routing/fallback, response caching, cost/rate controls, output guardrails/validation, and PII redaction. Business services call the gateway; they never call the LLM directly. (Details in doc 10.)

**Future Scaling.** See §2.6.

---

## 2.4 Dependency diagram (module dependencies)

```mermaid
flowchart LR
  subgraph Core
    AUTHm["Auth"]
    USERm["User/Profile"]
    ROADm["Career Roadmap"]
  end
  subgraph Prep
    LEARNm["Learning"]
    CODEm["Coding"]
    PROJm["Projects"]
    SPRINTm["Sprint/Tasks"]
  end
  subgraph Portfolio
    RESUMEm["Resume"]
    GHm["GitHub"]
    LIm["LinkedIn"]
  end
  subgraph Pipeline
    COMPm["Company CRM"]
    APPm["Applications"]
    INTm["Interviews"]
  end
  subgraph Cross["Cross-cutting"]
    SCOREm["Career Readiness Index Engine"]
    ANALYm["Analytics"]
    AIm["AI Gateway"]
    NOTIFm["Notifications"]
    ACHm["Achievements/Goals"]
  end

  USERm --> AUTHm
  ROADm --> USERm
  LEARNm --> ROADm
  CODEm --> ROADm
  PROJm --> ROADm
  PROJm --> GHm
  RESUMEm --> PROJm
  RESUMEm --> GHm
  APPm --> COMPm
  INTm --> APPm
  SPRINTm --> LEARNm
  SPRINTm --> CODEm
  SPRINTm --> PROJm
  SPRINTm --> APPm

  SCOREm --> LEARNm
  SCOREm --> CODEm
  SCOREm --> PROJm
  SCOREm --> RESUMEm
  SCOREm --> GHm
  SCOREm --> LIm
  SCOREm --> APPm
  SCOREm --> INTm

  ANALYm --> SCOREm
  AIm --> ANALYm
  NOTIFm -.events.-> SPRINTm
  NOTIFm -.events.-> APPm
  ACHm -.events.-> SCOREm
```

**Reading it:** Prep/Portfolio/Pipeline modules depend on Core (auth/user/roadmap). The **Score engine** reads from all activity modules. **Analytics** builds on the score + raw activity. **AI** consumes analytics + activity. **Notifications & Achievements** are event-driven consumers.

---

## 2.5 Request lifecycle (example: mark a coding problem solved)

```mermaid
sequenceDiagram
  participant U as User (Web)
  participant G as LB/Gateway
  participant API as FastAPI Router
  participant SVC as Coding Service
  participant DB as PostgreSQL
  participant BUS as Event Bus (Redis)
  participant W as Worker
  U->>G: PATCH /api/v1/coding/problems/{id} {status: solved}
  G->>API: routed (TLS terminated, rate-limit ok)
  API->>API: authN (JWT), authZ (owns resource), validate body
  API->>SVC: update_problem_status(...)
  SVC->>DB: UPDATE coding_problems ...
  SVC->>BUS: emit problem.solved
  SVC-->>API: updated problem
  API-->>U: 200 + problem JSON
  BUS-->>W: problem.solved
  W->>DB: recompute coding sub-score + streak
  W->>DB: upsert analytics snapshot + readiness_score
  W->>BUS: (maybe) achievement.unlocked → notification
```

---

## 2.6 Future scaling & microservices possibility

**Scaling levers (in order):**
1. Vertical + horizontal scaling of the stateless API behind the LB.
2. **Read replicas** for Postgres; move analytics reads to replicas; add connection pooling (PgBouncer).
3. **Caching** hot reads (dashboard, score) in Redis; CDN for static/SSG.
4. **Partition/scale workers** by queue (ai, integrations, notifications, analytics).
5. **Table partitioning** for high-volume time-series (`analytics_snapshots`, `notifications`, `coding_problems`).
6. **Search extraction** to OpenSearch when FTS becomes a bottleneck.

**Microservices extraction path** — extract along existing module seams when a domain needs independent scaling/ownership:

```mermaid
flowchart LR
  MONO["Modular Monolith (v1)"] --> S1["AI Service<br/>(GPU/cost isolation, provider mgmt)"]
  MONO --> S2["Analytics Service<br/>(heavy aggregation, own store)"]
  MONO --> S3["Notification Service<br/>(fan-out, delivery)"]
  MONO --> S4["Integration Service<br/>(GitHub/LinkedIn sync)"]
  MONO --> S5["Core API<br/>(user, learning, pipeline)"]
  S1 & S2 & S3 & S4 & S5 --- MQ["Message Bus (Redis/Kafka)"]
```

Extraction candidates (highest value first): **AI**, **Analytics**, **Notifications**, **Integrations** — each already isolated behind an interface and event-driven, so extraction is "deploy separately + swap in-process call for network call." A shared contracts package and the event bus keep coupling low. Kafka replaces Redis pub/sub when durability/replay is needed.

---

## 2.7 Environments

| Env | Purpose | Notes |
|-----|---------|-------|
| **local** | Dev | Docker Compose: api, worker, postgres, redis, minio, mailhog. |
| **preview** | Per-PR ephemeral | Auto-deployed by CI for review. |
| **staging** | Pre-prod | Mirrors prod; seeded data; runs E2E. |
| **production** | Live | HA Postgres, autoscaled API/workers, backups, monitoring. |

---

## 2.8 Folder structure

Monorepo (pnpm/turborepo for JS, uv/poetry for Python) so shared contracts live in one place.

```
placement-management-system/
├─ docs/                              # this documentation set
├─ apps/
│  ├─ web/                            # Next.js frontend
│  │  ├─ app/                         # app router: routes/layouts
│  │  │  ├─ (auth)/login, register
│  │  │  ├─ (app)/dashboard/
│  │  │  ├─ (app)/learning/
│  │  │  ├─ (app)/coding/
│  │  │  ├─ (app)/projects/
│  │  │  ├─ (app)/resume/
│  │  │  ├─ (app)/companies/ applications/ interviews/
│  │  │  ├─ (app)/sprint/ analytics/ coach/
│  │  │  └─ (app)/settings/
│  │  ├─ components/                  # ui/ (design system), charts/, forms/, layout/
│  │  ├─ features/                    # feature modules (hooks, api clients, views)
│  │  ├─ lib/                         # api client, auth, utils, query config
│  │  ├─ store/                       # zustand stores
│  │  ├─ styles/                      # tailwind, themes (light/dark tokens)
│  │  └─ tests/                       # vitest + RTL, playwright e2e
│  └─ api/                            # FastAPI backend
│     ├─ app/
│     │  ├─ main.py                   # app factory, middleware wiring
│     │  ├─ core/                     # config, security, logging, errors, deps
│     │  ├─ api/v1/                   # routers per module + router aggregation
│     │  ├─ modules/                  # domain modules (one folder each)
│     │  │  ├─ auth/                  # service.py, schemas.py, models.py, repo.py, router.py
│     │  │  ├─ users/  roadmap/
│     │  │  ├─ learning/ coding/ projects/ sprint/
│     │  │  ├─ resume/ github/ linkedin/
│     │  │  ├─ company/ application/ interview/
│     │  │  ├─ scoring/               # Career Readiness Index engine
│     │  │  ├─ analytics/ notifications/ achievements/ goals/
│     │  │  └─ ai/                    # AI gateway client, prompts, RAG
│     │  ├─ db/                       # session, base, mixins
│     │  ├─ events/                   # event bus, handlers
│     │  └─ workers/                  # celery app, tasks, beat schedules
│     ├─ migrations/                  # alembic
│     └─ tests/                       # pytest (unit/integration/api)
├─ packages/
│  ├─ contracts/                      # OpenAPI spec + generated TS types (shared)
│  ├─ ui-tokens/                      # design tokens (colors, spacing, typography)
│  └─ config/                         # shared lint/tsconfig/eslint/ruff configs
├─ infra/
│  ├─ docker/                         # Dockerfiles (web, api, worker)
│  ├─ compose/                        # docker-compose.*.yml
│  ├─ k8s/ or helm/                   # manifests/charts
│  └─ terraform/                      # cloud IaC
├─ .github/workflows/                 # CI/CD pipelines
├─ docker-compose.yml
└─ README.md
```

**Module convention (backend).** Each `modules/<name>/` contains: `models.py` (ORM), `schemas.py` (Pydantic I/O), `repo.py` (data access), `service.py` (business logic), `router.py` (HTTP), `events.py` (emitted/handled events), `tests/`. This keeps a module self-contained and extraction-ready.
