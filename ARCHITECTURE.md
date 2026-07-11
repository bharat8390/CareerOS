# CareerOS Architecture

The architecture is **frozen**. See:

- **[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)** — living architecture entry point.
- **[docs/02-software-architecture.md](docs/02-software-architecture.md)** — detailed specification.
- **[docs/17-architecture-freeze-report.md](docs/17-architecture-freeze-report.md)** — official V1/V2/V3 blueprint (frozen scope).
- **[docs/ADR/](docs/ADR/)** — Architecture Decision Records.

CareerOS is a **modular monolith** (FastAPI) + **Next.js** frontend, backed by
**PostgreSQL 16** and **Redis**, with event-driven internals and seams reserved for
future extraction of AI / Analytics / Notifications / Integrations services.
