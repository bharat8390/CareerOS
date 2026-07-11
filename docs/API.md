# API

> REST API contract, conventions, and versioning for CareerOS.
> **Owner:** Backend Lead · **Last reviewed:** on approval · **Status:** Stable

## 1. Purpose
Define the contract between clients and the backend: base path, auth, error envelope, pagination, and where the per-endpoint catalog lives. Keeps FE/BE in lock-step via generated types.

## 2. Contents
- Base URL (`/api/v1`), versioning policy, auth scheme (Bearer + refresh cookie).
- Standard **error envelope** and error-code catalog.
- Conventions: pagination, filtering, idempotency, rate limits, status codes.
- OpenAPI as the machine-readable contract; FE types generated from it.
- **Source of truth:** [`05-api-design.md`](05-api-design.md) + the generated OpenAPI (`/api/openapi.json` once built).

## 3. Standard Template
```markdown
# API
> <one-line API summary>
## Base URL & Versioning
## Authentication
## Standard Error Envelope
## Error Code Catalog
## Pagination / Filtering / Sorting
## Rate Limiting
## Idempotency
## OpenAPI & Generated Types
## Endpoint Catalog (link to 05)
## Deprecation Policy
```

## 4. Suggested Sections
Base URL/versioning · Auth · Error envelope · Error codes · Pagination/filtering · Rate limiting · Idempotency · OpenAPI/type-gen · Endpoint catalog · Deprecation policy.

## 5. Best Practices
- Contract-first: update OpenAPI + this doc **before** implementing an endpoint; regenerate FE types.
- One consistent error envelope; never leak stack traces or internals.
- Additive, backward-compatible changes within `v1`; breaking changes bump the version and follow the deprecation policy.
- Document validation and error codes per endpoint in doc 05.

## 6. Maintenance
- **Owner:** Backend Lead. **Trigger:** any endpoint add/change/remove.
- **Cadence:** per API PR; catalog reviewed each milestone.
- **Process:** the OpenAPI diff is part of code review; deprecations logged in `CHANGELOG.md`.
