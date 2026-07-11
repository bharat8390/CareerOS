# ADR-0005: Backend stack & runtime

- **Status:** Accepted
- **Date:** 2026-07-11
- **Author:** Backend Lead
- **Deciders:** CTO, Lead Engineer
- **Tags:** backend

## Context
CareerOS is API-first with async/background work (scoring, GitHub sync, notifications, later AI) and, in V2, RAG. It must be typed, testable, and fast to build solo. Layering in [`../02-software-architecture.md`](../02-software-architecture.md).

## Problem
What backend language, framework, and async runtime should CareerOS use?

## Decision
We will use **Python 3.12 + FastAPI**, **Pydantic v2** for validation, **SQLAlchemy 2.0 (typed) + Alembic** for data access/migrations, and **Uvicorn/Gunicorn** to serve. Background/scheduled work runs on **Celery (or ARQ) + Redis** with a beat scheduler. Layers are strict: thin routers → services (business logic) → repositories (data). No `Any`, no `getattr`/`setattr`; **mypy strict** + **ruff** enforced in CI.

## Alternatives Considered
- **Node/NestJS** — viable and one-language with FE, but Python is stronger for the data/AI/analytics story central to CareerOS and to the author's target roles.
- **Django** — batteries-included but heavier ORM/coupling; less natural for API-first + async + typed services.
- **Go** — great runtime, but slower domain iteration and weaker AI/data ecosystem for this product.
- **FastAPI + SQLAlchemy 2.0 (chosen)** — async, typed, OpenAPI-native, ideal for the data/AI roadmap.

## Trade-offs
Gain: OpenAPI-native contract (drives FE type-gen), async I/O, first-class data/AI libraries, strong typing. Give up: raw throughput vs. Go (irrelevant at V1/V2 scale); two languages across the stack (accepted).

## Consequences
- **Positive:** clean layered testable code; OpenAPI → typed FE client; smooth path to V2 AI Gateway/RAG.
- **Negative:** async correctness and typed SQLAlchemy have a learning curve → covered by tests + standards.
- **Follow-ups:** worker + Redis in Compose; error-envelope middleware; `core` event bus; scoring runs as events/tasks.

## References
docs 02, 05, 16 (standards), 10 (AI Gateway, V2).
