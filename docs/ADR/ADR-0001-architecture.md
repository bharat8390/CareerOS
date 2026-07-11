# ADR-0001: Modular monolith architecture (microservices-ready)

- **Status:** Accepted
- **Date:** 2026-07-11
- **Author:** Solution Architect / CTO
- **Deciders:** CTO, Lead Engineer
- **Tags:** architecture

## Context
CareerOS V1 is built by a single engineering student during placement season. It spans many domains (learning, coding, projects, applications, interviews, analytics, AI) but must ship, stay maintainable, and still look enterprise-grade. Frozen architecture in [`../02-software-architecture.md`](../02-software-architecture.md) and [`../17-architecture-freeze-report.md`](../17-architecture-freeze-report.md).

## Problem
Should V1 be a set of microservices or a single deployable application?

## Decision
We will build a **modular monolith**: one deployable FastAPI application composed of clearly bounded modules (`modules/<name>/` with `models/schemas/repo/service/router/events`), an event-driven internal core, and explicit interfaces. Boundaries are drawn so **AI, Analytics, Notifications, and Integrations** can later be extracted as services without rewrites.

## Alternatives Considered
- **Microservices from day one** — operationally heavy (multiple deploys, network boundaries, distributed tracing/debugging); unrealistic for a solo builder; premature.
- **Unstructured monolith** — fast initially but rots into a big ball of mud; poor showcase; hard to extract later.
- **Modular monolith (chosen)** — single deploy, clean seams, extraction-ready.

## Trade-offs
Gain: velocity, simple local/CI/deploy, one codebase to reason about. Give up: independent per-domain scaling/deploys (accepted; deferred to V3 via seams).

## Consequences
- **Positive:** simple ops; strong module discipline; clear extraction path (doc 02 §2.6).
- **Negative:** must enforce boundaries by convention/review (no network to force them).
- **Follow-ups:** import-boundary lint rule; event bus in `core`; ADR-0002/0005 for data/runtime.

## References
docs 02, 16, 17.
