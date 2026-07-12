# CareerOS API (`apps/api`)

FastAPI backend for CareerOS.

**Status (S1-5):** the application factory (`create_app`), typed environment config,
request-id middleware, the standard error envelope, `/health` + `/ready` endpoints,
structured JSON logging, and the **SQLAlchemy 2.0 async database base + Alembic baseline
migration** are in place. Feature modules land in later stories per the frozen
architecture (`docs/02`, `docs/16`). The `/api/v1` router is mounted but has no feature
routes yet; the Redis readiness check arrives with S1-8.

## Database & migrations

Async SQLAlchemy 2.0 (`asyncpg`). Set `DATABASE_URL` (see `.env.example`) then:

```bash
cd apps/api && source .venv/bin/activate
export DATABASE_URL=postgresql+asyncpg://careeros:careeros@localhost:5432/careeros
alembic upgrade head     # apply the baseline (extensions + feature_flags + app_meta)
alembic downgrade base   # roll back
```

The baseline migration enables `pgcrypto`, `citext`, and `pg_trgm` and creates the
`feature_flags` and `app_meta` infrastructure tables (no domain tables yet). When
`DATABASE_URL` is set, `/ready` includes a `database` check.

## Run (dev)

```bash
export APP_ENV=development
uvicorn app.main:app --reload --port 8000
# OpenAPI docs at http://localhost:8000/api/docs
```

## Setup

```bash
cd apps/api
python3.12 -m venv .venv
source .venv/bin/activate
pip install -e ".[dev]"
```

## Checks

```bash
ruff check .            # lint
ruff format --check .   # formatting
mypy .                  # strict type checking
pytest                  # tests
```

## Layout (target, per docs/16 §9)

```
app/
├─ __init__.py     # package metadata (S1-1)
├─ main.py         # app factory + wiring          (S1-3)
├─ core/           # config, errors, logging, db    (S1-3 → S1-5)
├─ api/            # versioned router mounting       (S1-3)
└─ modules/<name>/ # models/schemas/repo/service/router/events/tests (per feature story)
```
