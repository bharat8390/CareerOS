# CareerOS — AI-Powered Career Intelligence Platform
### Complete Software Design & Architecture Documentation

> **Status:** Design phase (no application code). This package is a hand-off-ready specification for a professional development team.
> **Owner:** Product + Engineering
> **KPI (North Star):** *Get a job before graduation* — measured by **Career Readiness Index** and **Offer Rate**.

---

## Document Index

| # | Document | Purpose |
|---|----------|---------|
| 01 | [Product Definition](01-product-definition.md) | Executive summary, problem/vision/mission, goals, users, personas, user stories, functional & non-functional requirements, feature list, roadmap, scope, tech decisions |
| 02 | [Software Architecture](02-software-architecture.md) | System layers, diagrams, dependency graph, folder structure, scaling & microservices path |
| 03 | [Database Design](03-database-design.md) | ER model, entity relationships, keys, indexes, normalization, per-table rationale |
| 04 | [Database Schema (DDL)](04-database-schema.sql) | Full PostgreSQL schema with constraints, indexes, triggers |
| 05 | [API Design](05-api-design.md) | REST contract: method, endpoint, request, response, validation, errors |
| 06 | [UI/UX Design](06-ui-ux-design.md) | Navigation, pages, component library, theming, responsive & dark/light mode |
| 07 | [User Journeys](07-user-journeys.md) | End-to-end flows and per-module flow diagrams |
| 08 | [Module Design](08-module-design.md) | Each of the 13 modules: purpose, features, I/O, KPIs, tables, APIs, UI |
| 09 | [Analytics](09-analytics.md) | Dashboards, KPIs, chart specifications, funnels |
| 10 | [AI Features](10-ai-features.md) | Career coach, resume review, mock interview, recommendations, prediction |
| 11 | [Security](11-security.md) | AuthN/AuthZ, RBAC, encryption, validation, rate limiting, error handling |
| 12 | [Testing Strategy](12-testing-strategy.md) | Unit, integration, API, UI, E2E, quality gates |
| 13 | [Deployment](13-deployment.md) | Deployment topology, CI/CD, Docker, env vars, cloud |
| 14 | [Development Roadmap](14-development-roadmap.md) | 12 delivery phases with entry/exit criteria |
| 15 | [Improvement Roadmap (CTO Review)](15-improvement-roadmap.md) | CareerOS v2 vision: rebrand, CRI, Skill/Resume/Project/Company/Interview Intelligence engines, prediction, AI Mentor, and v1/v2/v3 product evolution |
| 16 | [Engineering Implementation Plan](16-engineering-implementation-plan.md) | Implementation plan, build order, dependency graph, module deps, repo structure, branching & commit strategy, coding standards, folder structure, timeline |
| 17 | [Architecture Freeze Report](17-architecture-freeze-report.md) | **Official blueprint.** V1/V2/V3 classification of all 33 improvements, complexity/effort/deps/value, change log, backlog, priority matrix, MVP/V2/V3 scopes, freeze statement |
| 18 | [Sprint 1 Task Breakdown (M1 Foundations)](18-sprint-01-task-breakdown.md) | Sprint goal, backlog, stories→tasks, story points, acceptance criteria, dependency order, PR slicing, sprint Definition of Done, risks |

---

## How to read this set

1. Start with **01 Product Definition** to understand *what* we are building and *why*.
2. Read **02 Architecture** for the *how* at a system level.
3. **03/04** define the data foundation; **05** the contract between frontend and backend.
4. **06/07/08** define the experience and per-module behavior.
5. **09/10** define the intelligence layers.
6. **11/12/13/14** define how we ship it safely and in order.
7. **15** is the CTO review that sets the CareerOS v2 direction (intelligence engines + v1/v2/v3 evolution) layered on top of the above.
8. **16** is the engineering implementation plan; **17** is the **frozen official blueprint** (V1/V2/V3 scope).

---

## Engineering documentation set (OSS-style, living docs)

The numbered docs (00–17) are the **detailed frozen specifications**. The files below are the professional, open-source-style **living entry points** used during implementation — each names its *source of truth* in the numbered set (no duplication). See [DOCUMENTATION-STANDARDS.md](DOCUMENTATION-STANDARDS.md) for conventions, ownership, and maintenance.

| Doc | Purpose |
|-----|---------|
| [DOCUMENTATION-STANDARDS](DOCUMENTATION-STANDARDS.md) | The doc-set standard: layout, conventions, meta-template, ownership/cadence |
| [PRODUCT](PRODUCT.md) | Product overview, vision, CRI, version scope |
| [ARCHITECTURE](ARCHITECTURE.md) | System model, layers, module boundaries, seams |
| [DATABASE](DATABASE.md) | Data model, schema conventions, migration practice |
| [API](API.md) | REST contract, error envelope, versioning, OpenAPI |
| [DEVELOPMENT](DEVELOPMENT.md) | Local setup + day-to-day workflow |
| [DEPLOYMENT](DEPLOYMENT.md) | Environments, CI/CD, env-var contract, ops |
| [TESTING](TESTING.md) | Test pyramid, coverage, quality gates |
| [SECURITY](SECURITY.md) | AuthN/Z, data protection, disclosure policy |
| [CONTRIBUTING](CONTRIBUTING.md) | Branching, commits, PR process, Definition of Done |
| [CHANGELOG](CHANGELOG.md) | Keep-a-Changelog record of user-facing changes |
| [RELEASES](RELEASES.md) | SemVer policy, release checklist, release notes |
| [ROADMAP](ROADMAP.md) | Milestones + V1/V2/V3 boundaries + deferred backlog |
| [FAQ](FAQ.md) | Recurring product/engineering questions |
| [GLOSSARY](GLOSSARY.md) | Canonical term definitions |
| [ADR/](ADR/) | Architecture Decision Records (template + ADR-0001…0005) |

## Glossary (used throughout)

| Term | Meaning |
|------|---------|
| **Career Readiness Index (CRI)** | Composite 0–100 score (formerly *Employability Score*) combining learning, coding, DSA, projects, resume, GitHub, LinkedIn, applications, interview performance, communication, consistency, and (optional) certifications. See doc 15. |
| **Sprint** | Time-boxed (default 1–2 week) plan of tasks across learning/coding/projects. |
| **Application Funnel** | Saved → Applied → OA → Interview → Offer → Accepted. |
| **Domain** | A learning subject (Python, SQL, DSA, …). |
| **Topic / Sub-topic** | Hierarchical breakdown inside a Domain. |
| **Career Roadmap** | Role-targeted skill/milestone path (e.g., Data Engineer). |
| **Tenant** | A single student account (multi-tenant SaaS; org/college tenancy is a future extension). |
