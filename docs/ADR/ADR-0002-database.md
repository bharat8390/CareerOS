# ADR-0002: PostgreSQL as the system of record

- **Status:** Accepted
- **Date:** 2026-07-11
- **Author:** Database Architect
- **Deciders:** CTO, Lead Engineer
- **Tags:** database

## Context
CareerOS is relational (users, roadmaps, learning, applications, interviews) but also needs JSON flexibility (KPI blobs, resume section content) and, in V2, vector search for RAG. Model/conventions in [`../03-database-design.md`](../03-database-design.md); DDL in [`../04-database-schema.sql`](../04-database-schema.sql).

## Problem
Which primary datastore should CareerOS standardize on for V1 (and beyond)?

## Decision
We will use **PostgreSQL 16** as the single system of record: UUID PKs, `TIMESTAMPTZ` (UTC), tenant scoping by `user_id`, 3NF with justified denormalization, JSONB for semi-structured fields, and **pgvector reserved for V2** RAG. Schema changes go through **Alembic** migrations; no hand-editing of the live schema.

## Alternatives Considered
- **NoSQL (MongoDB)** — poor fit for highly relational, multi-entity integrity; weak cross-entity queries/analytics.
- **Postgres + separate vector DB now** — extra infra for a V2 need; unnecessary in V1.
- **Postgres + JSONB + pgvector (chosen)** — one engine covers relational, document, and (later) vector needs.

## Trade-offs
Gain: integrity, powerful SQL/analytics, one datastore to operate, easy local Docker. Give up: independent scaling of a dedicated vector/document store (deferred; pgvector suffices at V1/V2 scale).

## Consequences
- **Positive:** simple ops; strong consistency; analytics/funnels in SQL; fewer moving parts for a solo builder.
- **Negative:** vertical-scale ceiling → mitigated by read replicas/partitioning (doc 02 §2.6) when needed.
- **Follow-ups:** migration review checklist; validate every migration on real Postgres+pgvector; partitioning plan for time-series tables in V2.

## References
docs 03, 04, 02 §2.6, 17.
