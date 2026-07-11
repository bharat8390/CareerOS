# 12 — Testing Strategy

Goal: ship confidently and fast via a balanced test pyramid, contract testing, and quality gates in CI.

## 12.1 Test pyramid

```
        ▲  E2E (Playwright)         few, critical journeys
       ▲▲  UI component (Vitest+RTL) + API/integration (pytest)
     ▲▲▲▲  Unit tests (pytest / Vitest)   many, fast
```

| Level | Scope | Tools | Target coverage |
|-------|-------|-------|-----------------|
| Unit | Pure functions, services, score engine, validators, utils | pytest (BE), Vitest (FE) | ≥ 80% core domains |
| Integration | Service ↔ DB ↔ Redis, repositories, migrations | pytest + testcontainers/ephemeral Postgres | key flows |
| API/contract | HTTP endpoints vs. OpenAPI, auth, validation, errors | pytest + httpx, Schemathesis (fuzz from spec) | all endpoints |
| UI | Components, hooks, forms, chart wrappers | Vitest + React Testing Library | key components |
| E2E | Golden-path journeys across FE+BE | Playwright | critical paths |

## 12.2 Unit testing
- **Backend:** each module's `service.py` tested with mocked repositories; **Career Readiness Index engine** tested with fixtures covering weightings, edge cases (empty data, max/min), and role variations; validators/utilities.
- **Frontend:** pure logic (formatters, reducers, hooks), Zustand stores, chart data transforms.
- **Determinism:** freeze time; seed randomness; no network.

## 12.3 Integration testing
- Spin ephemeral Postgres + Redis (testcontainers/Docker). Test repositories against real SQL, transactions, cascade/soft-delete behavior, and **Alembic migrations apply cleanly + are reversible**.
- Event handlers: assert domain events trigger correct side-effects (score recompute, notifications, achievements).

## 12.4 API testing
- Every endpoint: happy path, validation failures (`400/422`), authN (`401`), authZ/ownership (`403/404`), conflict (`409`), rate limit (`429`).
- **Contract testing:** generate cases from the OpenAPI spec with **Schemathesis**; verify responses match schemas. Frontend types generated from the same spec keep FE/BE in sync.
- Idempotency and pagination/filtering verified.

## 12.5 UI testing
- Component tests: rendering, states (loading/empty/error), interactions, accessibility (roles, keyboard) via RTL + jest-axe.
- Visual regression (optional): Playwright/Storybook snapshots for the design system.
- Mock the API layer (MSW) for deterministic component tests.

## 12.6 End-to-end testing
Critical journeys (doc 07) automated in Playwright against a seeded staging stack:
1. Register → verify → onboarding → dashboard.
2. Log learning progress → revision scheduled.
3. Log coding problem → streak/heatmap updates.
4. Create project → complete milestone.
5. Build resume → ATS scan → export.
6. Save company → create application → move funnel → add interview → mark offer.
7. Plan sprint → complete daily tasks → weekly review.
8. Career Readiness Index updates after activity.
9. AI coach returns guidance + creates a task (mock provider).

Run cross-browser (Chromium/Firefox/WebKit) + mobile viewport; capture traces/screenshots on failure.

## 12.7 Non-functional testing
- **Performance/load:** k6/Locust against key endpoints; assert P95 latency & throughput SLOs; DB query profiling (no N+1; index usage).
- **Security:** SAST (Bandit/Semgrep, ESLint security), dependency scanning (Snyk/Dependabot), secret scanning, DAST (OWASP ZAP) against staging, periodic pen-test.
- **Accessibility:** automated axe scans + manual keyboard/screen-reader checks (WCAG 2.1 AA).
- **AI evals:** golden-set prompts with rubric scoring; guardrail tests (refuses unsafe/fabricated outputs); schema-conformance of structured outputs; regression suite on prompt changes.
- **Chaos/resilience (later):** dependency-failure injection (AI/provider down) → graceful degradation verified.

## 12.8 Test data & environments
- **Factories/fixtures** (factory_boy / test builders) for entities; deterministic seed script for staging/E2E.
- **Isolation:** each test gets a clean transactional DB (rollback) or fresh container.
- **PII:** synthetic data only; never production PII in tests.

## 12.9 Quality gates (CI)
Merge blocked unless:
- Lint + type checks pass (ruff/mypy; eslint/tsc).
- Unit + integration + API tests pass; coverage ≥ threshold on changed core code.
- Contract tests pass (OpenAPI conformance).
- Security scans (SAST/deps/secrets) pass with no criticals.
- E2E smoke suite passes on preview/staging.
- Build succeeds; migrations apply cleanly.

## 12.10 Practices
- **TDD** encouraged for the score engine and business rules.
- **PR checks** run the fast suite; nightly runs full E2E + load + DAST.
- **Flaky-test policy:** quarantine + fix; no disabling to go green.
- **Coverage** tracked and trended; regressions flagged in PR.
