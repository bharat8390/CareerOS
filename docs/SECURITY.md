# SECURITY

> Security model, controls, and vulnerability handling for CareerOS.
> **Owner:** Security Owner · **Last reviewed:** on approval · **Status:** Stable

## 1. Purpose
Document the security posture — authN/Z, data protection, and how vulnerabilities are reported and handled — so security is verifiable, not assumed.

## 2. Contents
- Authentication (Argon2id, JWT + rotating refresh, OAuth2+PKCE, optional TOTP).
- Authorization (RBAC + ownership checks; tenant isolation by `user_id`).
- Data protection (TLS, encryption at rest, secrets handling, PII).
- Input validation, rate limiting, CSRF/XSS, file handling.
- Auditing, logging hygiene, dependency/secret scanning.
- Responsible-disclosure / vulnerability-reporting policy.
- **Source of truth:** [`11-security.md`](11-security.md); auth decision in [`ADR-0003`](ADR/ADR-0003-authentication.md).

## 3. Standard Template
```markdown
# SECURITY
> <one-line security summary>
## Threat Model (brief)
## Authentication
## Authorization & Tenancy
## Data Protection & Encryption
## Input Validation
## Rate Limiting & Abuse
## Secrets Management
## Auditing & Logging
## Dependency & Secret Scanning
## Vulnerability Reporting (Disclosure)
## Incident Response
```

## 4. Suggested Sections
Threat model · Authentication · Authorization/tenancy · Data protection · Input validation · Rate limiting · Secrets · Auditing/logging · Scanning · Vulnerability reporting · Incident response.

## 5. Best Practices
- Never log secrets/tokens/PII; redact at the boundary.
- Least privilege everywhere (DB roles, tokens, OAuth scopes).
- Security controls are cross-cutting and tested; scans run in CI and block on criticals.
- Never weaken a control to pass a build — escalate instead.

## 6. Maintenance
- **Owner:** Security Owner. **Trigger:** new control, dependency CVE, threat change, incident.
- **Cadence:** quarterly review + immediately after any incident.
- **Process:** control changes reference an ADR when architectural; disclosures tracked privately then summarized here.
