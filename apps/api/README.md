# CareerOS API (`apps/api`)

FastAPI backend for CareerOS.

**Status (S1-3):** the application factory (`create_app`), typed environment config,
request-id middleware, and the standard error envelope are in place. Health endpoints
and structured logging (S1-4), the database + Alembic (S1-5), and feature modules land
in later stories per the frozen architecture (`docs/02`, `docs/16`). The `/api/v1` router
is mounted but has no feature routes yet.

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
