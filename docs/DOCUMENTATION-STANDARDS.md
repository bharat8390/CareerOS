# CareerOS Documentation Standards

> **Purpose of this file:** define the professional, OSS-grade documentation
> structure for CareerOS, the conventions every doc follows, and how the set is
> maintained. It does **not** change the frozen architecture (docs 01–17); it
> organizes how we *write and keep* documentation during implementation.

## The canonical `/docs` layout

```
docs/
├── DOCUMENTATION-STANDARDS.md   # this file — meta standard + index
├── PRODUCT.md
├── ARCHITECTURE.md
├── DATABASE.md
├── API.md
├── DEVELOPMENT.md
├── DEPLOYMENT.md
├── TESTING.md
├── SECURITY.md
├── CONTRIBUTING.md
├── CHANGELOG.md
├── RELEASES.md
├── ROADMAP.md
├── FAQ.md
├── GLOSSARY.md
└── ADR/
    ├── ADR-0000-template.md
    ├── ADR-0001-architecture.md
    ├── ADR-0002-database.md
    ├── ADR-0003-authentication.md
    ├── ADR-0004-frontend.md
    └── ADR-0005-backend.md
```

> **Relationship to the numbered design set (00–17).** The numbered docs are the
> **detailed frozen specifications**. These top-level named docs are the
> **living, OSS-style entry points** that summarize and link into the numbered
> specs. Each named doc names its **source of truth** so there is exactly one
> authoritative place per fact (no duplication, no drift).

## Documentation conventions (apply to every doc)

| Convention | Rule |
|-----------|------|
| Format | GitHub-Flavored Markdown; Mermaid for diagrams; relative links between docs. |
| Front matter | Each doc starts with a one-line purpose blockquote + an **Owner** and **Last reviewed** line. |
| Tone | Concise, factual, present tense; write for a new engineer joining the team. |
| Headings | Sentence case; one `#` H1 per file (the title). |
| Line length | Wrap prose ~100 cols; never wrap tables/links. |
| Code/paths | Backtick all identifiers, paths, commands, env vars. |
| Single source of truth | State a fact once; elsewhere link to it. |
| Diagrams as code | Mermaid/PlantUML in-repo (reviewable in PRs), never binary images for architecture. |
| Change control | Docs change via PR with the same review bar as code; doc updates ship in the *same* PR as the behavior they describe. |
| Status labels | `Draft` → `Reviewed` → `Stable` → `Deprecated` where relevant. |

## Meta-template every top-level doc uses

Each named doc in this set is written to answer six questions (the shape the CTO mandated):

1. **Purpose** — why this document exists / what question it answers.
2. **Contents** — what information lives here (and what deliberately does not).
3. **Standard Template** — the reusable skeleton to fill/keep filled.
4. **Suggested Sections** — the recommended section list.
5. **Best Practices** — how to write and keep it high-quality.
6. **Maintenance** — owner, cadence, triggers, and review process.

## Ownership & cadence (summary)

| Doc | Primary owner | Update trigger | Review cadence |
|-----|---------------|----------------|----------------|
| PRODUCT | Product Manager | scope/vision change | per milestone |
| ARCHITECTURE | Solution Architect | structural change (needs ADR) | per milestone |
| DATABASE | Database Architect | schema/migration | per migration |
| API | Backend Lead | endpoint change | per API PR |
| DEVELOPMENT | Lead Engineer | tooling/workflow change | as needed |
| DEPLOYMENT | DevOps | infra/pipeline change | per release |
| TESTING | QA Lead | strategy/gate change | per milestone |
| SECURITY | Security Owner | control/threat change | quarterly + on incident |
| CONTRIBUTING | Lead Engineer | process change | as needed |
| CHANGELOG | Release manager (all) | every user-facing change | every PR/release |
| RELEASES | Release manager | every release | every release |
| ROADMAP | Product + CTO | plan change | per milestone |
| FAQ | All | recurring question | as needed |
| GLOSSARY | All | new term | as needed |
| ADR/* | Author + Architect | any architectural decision | on supersede |

## Maintenance of this standards file

- **Owner:** Lead Engineer.
- **Triggers:** adding/removing a doc, changing a convention, or a tooling change (e.g., docs linter).
- **Review:** revisited at the start of each version (V1/V2/V3) to confirm the set still matches how the team works.
- **Automation (planned):** markdown-lint + link-checker + "docs changed with code" check in CI (see `TESTING.md` / `CONTRIBUTING.md`).
