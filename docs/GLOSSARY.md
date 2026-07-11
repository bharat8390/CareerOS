# GLOSSARY

> Canonical definitions of CareerOS terms and acronyms.
> **Owner:** All contributors · **Last reviewed:** on approval · **Status:** Living

## 1. Purpose
Provide one authoritative definition per term so product, docs, code, and UI use consistent language.

## 2. Contents
- Product terms (CRI, Application Funnel, Roadmap, Sprint, Portfolio Mode…).
- Engineering terms (Modular Monolith, AI Gateway, Domain Event, Tenant…).
- Acronyms.
- **Source of truth:** aligns with the glossary in [`00-README-index.md`](00-README-index.md).

## 3. Standard Template
```markdown
# GLOSSARY
> <one-line summary>
## Terms
| Term | Definition | See also |
|------|------------|----------|
| <Term> | <one-sentence definition> | <doc/link> |
```

## 4. Suggested Sections
A single alphabetized table (or grouped Product / Engineering) with **Term · Definition · See also**.

## 5. Best Practices
- One sentence per definition; link to detail rather than expanding here.
- Define a term once; code/UI/docs must match this spelling and meaning.
- Add a term the first time it appears in a doc or the UI.

## 6. Terms
| Term | Definition | See also |
|------|------------|----------|
| **CareerOS** | AI-Powered Career Intelligence Platform helping students get placed. | `PRODUCT.md` |
| **Career Readiness Index (CRI)** | Weighted 0–100 composite of learning, coding, projects, resume, GitHub, LinkedIn, applications, interview, communication, consistency, certification. | doc 17 |
| **Application Funnel** | Saved → Applied → OA → Interview → Offer → Accepted. | doc 09 |
| **Career Roadmap** | Role-targeted skill/milestone path (e.g., Data Engineer). | doc 01 |
| **Sprint** | Time-boxed plan of tasks across learning/coding/projects. | doc 08 |
| **Portfolio Mode** | Recruiter-facing public profile (projects, skills, CRI, GitHub, timeline). | doc 17 §29 |
| **Modular Monolith** | One deployable API of clearly bounded modules with extraction seams. | `ARCHITECTURE.md` |
| **AI Gateway** | The single mediated path to the LLM (prompts, RAG, guardrails, cost). | doc 10 |
| **Domain Event** | Internal event (e.g., `problem.solved`) that triggers scoring/notifications. | doc 02 |
| **Tenant** | A single student account (multi-tenant isolation by `user_id`). | doc 03 |
| **ADR** | Architecture Decision Record — one decision, with context and consequences. | `ADR/` |

## 7. Maintenance
- **Owner:** all contributors. **Trigger:** a new term enters docs/UI/code.
- **Cadence:** reviewed each milestone; de-duplicated against doc 00.
