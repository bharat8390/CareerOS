# CareerOS API (`apps/api`)

FastAPI backend for CareerOS.

**Status (S1-1):** project scaffold only — Python packaging, Ruff, MyPy (strict), and
pytest are configured; the `app` package contains metadata only. The application
factory, configuration, error envelope, health endpoints, database, and modules are
introduced in later stories (S1-3 → S1-5 …) per the frozen architecture (`docs/02`, `docs/16`).

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
