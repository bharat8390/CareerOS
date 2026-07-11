# DATABASE

> Data model, schema conventions, and migration practice for CareerOS.
> **Owner:** Database Architect · **Last reviewed:** on approval · **Status:** Stable

## 1. Purpose
Explain the relational model and the rules every table/migration follows, so schema changes stay consistent, safe, and tenant-isolated.

## 2. Contents
- ER model overview and entity relationships.
- Schema conventions (UUID PKs, `TIMESTAMPTZ` UTC, `user_id` tenancy, 3NF, indexing, enums, triggers).
- Migration workflow (Alembic) and review checklist.
- Per-table rationale and the CRI time series (`readiness_scores`).
- **Source of truth:** [`03-database-design.md`](03-database-design.md) and DDL [`04-database-schema.sql`](04-database-schema.sql). Do not hand-edit generated schema; change via migration.

## 3. Standard Template
```markdown
# DATABASE
> <one-line data summary>
## ER Overview (Mermaid)
## Conventions (PKs, timestamps, tenancy, normalization)
## Indexing Strategy
## Enums & Constraints
## Triggers & Views
## Migration Workflow (Alembic)
## Migration Review Checklist
## Table Catalog (link to 03)
## Related ADRs
```

## 4. Suggested Sections
ER overview · Conventions · Indexing · Enums/constraints · Triggers/views · Migration workflow · Migration review checklist · Table catalog · Related ADRs.

## 5. Best Practices
- Every table: UUID PK, `created_at`/`updated_at` (`TIMESTAMPTZ`), tenant-scoped by `user_id`; composite indexes lead with `user_id`.
- Backward-compatible migrations (expand→migrate→contract); never destructive without a reviewed plan + backup.
- One migration per logical change; migration ships in the same PR as the code needing it.
- Validate every migration against a real Postgres (+pgvector) before merge.

## 6. Maintenance
- **Owner:** Database Architect. **Trigger:** any schema change.
- **Cadence:** reviewed per migration; catalog reviewed each milestone.
- **Process:** migration PR updates DDL notes here + rationale in doc 03; schema-affecting decisions get an ADR (see `ADR-0002`).
