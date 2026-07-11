# CareerOS Coding Standards

The authoritative coding standards are defined in
**[docs/16-engineering-implementation-plan.md](docs/16-engineering-implementation-plan.md) §8**.

Summary:

**Backend (Python 3.12)** — Ruff + Ruff format, MyPy **strict**, no `Any`/`getattr`/`setattr`;
thin routers → services (business logic) → repositories (data access); Pydantic v2 validation;
SQLAlchemy 2.0 typed models; UTC timestamps; tenant-scoped queries; standard error envelope;
no hard-coded secrets.

**Frontend (TypeScript)** — `strict` mode, ESLint + Prettier, no `any`; Next.js server components
for data-heavy pages; TanStack Query for server state; Zustand for light UI state; generated typed
API client; reusable, accessible components; design tokens + shadcn/ui.

**Testing** — pytest, Vitest, React Testing Library, Playwright, axe, Schemathesis;
new domain logic ≥ 85% coverage; no red CI merges.

**Documentation** — a README per module; endpoints/events/decisions documented; ADRs in `docs/ADR/`.
