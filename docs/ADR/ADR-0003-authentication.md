# ADR-0003: Authentication & session strategy

- **Status:** Accepted
- **Date:** 2026-07-11
- **Author:** Security Owner / Backend Lead
- **Deciders:** CTO, Lead Engineer
- **Tags:** security, backend

## Context
CareerOS holds a student's career data and (V1) a public Portfolio Mode. It needs secure, standard, stateless auth that scales horizontally and supports social login. Controls in [`../11-security.md`](../11-security.md).

## Problem
How do users authenticate and how are sessions represented?

## Decision
We will use **JWT access tokens (short-lived) + rotating refresh tokens** stored in **HttpOnly, Secure, SameSite cookies**; **Argon2id** password hashing; **OAuth2 + PKCE** social login (Google/GitHub); and **optional TOTP 2FA**. AuthZ is **RBAC + resource-ownership checks**, with tenant isolation by `user_id`. Refresh tokens are hashed at rest and rotated on use (reuse detection revokes the family).

## Alternatives Considered
- **Server-side sessions (stateful)** — simple but requires sticky sessions/shared store; conflicts with stateless-scale goal.
- **Long-lived JWT only** — cannot revoke; poor security posture.
- **Third-party IdP (Auth0/Clerk)** — fast but adds cost/vendor lock-in and less to showcase; revisit for V3 B2B SSO.
- **JWT access + rotating refresh (chosen)** — stateless, revocable via refresh store, standard.

## Trade-offs
Gain: stateless API, horizontal scale, revocation via refresh rotation, strong hashing. Give up: some implementation complexity (rotation/reuse detection) vs. a managed IdP.

## Consequences
- **Positive:** secure, standard, portable; no sticky sessions; social login supported.
- **Negative:** must implement rotation/blacklist carefully and test it (first-class unit/API/E2E tests).
- **Follow-ups:** auth rate-limiting + audit logging; refresh-token table + reuse detection; 2FA enrollment flow.

## References
docs 11, 05 (auth endpoints), 17 (M2).
