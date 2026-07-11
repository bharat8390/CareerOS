# ARCHITECTURE

> System architecture entry point for CareerOS.
> **Owner:** Solution Architect · **Last reviewed:** on approval · **Status:** Stable (frozen)

## 1. Purpose
Give engineers a fast, accurate mental model of the system: the layers, module boundaries, request/event flow, and the seams reserved for future scaling — without rederiving the full spec.

## 2. Contents
- Architectural principles (modular monolith, API-first, event-driven, stateless).
- High-level system, logical-layer, and module-dependency diagrams (Mermaid).
- Request lifecycle + domain-event model.
- Scaling levers and microservice extraction seams.
- Folder structure and module convention.
- **Source of truth:** [`02-software-architecture.md`](02-software-architecture.md); freeze deltas in [`17-architecture-freeze-report.md`](17-architecture-freeze-report.md). Decisions are recorded in [`ADR/`](ADR/).

## 3. Standard Template
```markdown
# ARCHITECTURE
> <one-line system summary>
## Principles
## System Diagram (Mermaid)
## Logical Layers
## Module Boundaries & Dependencies
## Request Lifecycle
## Domain Events
## Data & Storage
## Scaling & Extraction Seams
## Folder Structure
## Related ADRs
```

## 4. Suggested Sections
Principles · System diagram · Logical layers · Module boundaries/dependencies · Request lifecycle · Domain events · Data/storage · Scaling & extraction seams · Folder structure · Related ADRs.

## 5. Best Practices
- Diagrams as code (Mermaid) so they review in PRs and never rot as binaries.
- Every structural claim links to the ADR that decided it.
- Show boundaries and dependency *direction* (deps point inward); call out what must **not** import what.
- Keep "future/extraction" clearly separated from "current" so V1 stays simple.

## 6. Maintenance
- **Owner:** Solution Architect. **Trigger:** any structural change — which **requires a new ADR** before this doc is edited.
- **Cadence:** reviewed each milestone; frozen for V1 per doc 17.
- **Process:** architecture PRs update this file + the relevant ADR + diagrams together.
