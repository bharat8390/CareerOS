# PRODUCT

> Product overview, vision, and scope for CareerOS.
> **Owner:** Product Manager · **Last reviewed:** on approval · **Status:** Stable

## 1. Purpose
The single entry point that explains **what CareerOS is, who it is for, and why it exists**. Onboards any reader (engineer, designer, stakeholder, recruiter reviewing the portfolio) to the product in minutes and links to the authoritative product spec.

## 2. Contents
- The elevator pitch and North-Star KPI.
- Target users/personas and the core problem.
- The value proposition and the Career Readiness Index (CRI) concept.
- Feature summary by version (V1/V2/V3) — *summary only*.
- What is deliberately **out of scope**.
- **Source of truth:** [`01-product-definition.md`](01-product-definition.md) and the version scopes in [`17-architecture-freeze-report.md`](17-architecture-freeze-report.md). This file summarizes; it does not restate them.

## 3. Standard Template
```markdown
# PRODUCT
> <one-line product summary>
## Vision & Mission
## North-Star KPI
## Target Users & Personas
## Problem → Solution
## Career Readiness Index (CRI)
## Feature Summary (V1 / V2 / V3)   <!-- link to 17 -->
## Out of Scope
## Related Docs
```

## 4. Suggested Sections
Vision & Mission · North-Star KPI · Target Users/Personas · Problem/Solution · CRI concept · Feature summary by version · Out of scope · Related docs.

## 5. Best Practices
- Lead with the one-sentence pitch; keep it jargon-free.
- Summarize, link for detail — never duplicate the full PRD.
- Every feature claim maps to a version in doc 17 (no "coming soon" ambiguity).
- Keep persona names consistent with doc 01.

## 6. Maintenance
- **Owner:** Product Manager. **Triggers:** vision/scope/persona change, version boundary change.
- **Cadence:** reviewed at each milestone and version cut.
- **Process:** PR-reviewed; changes to scope require a matching update in `ROADMAP.md` and (if architectural) an ADR.
