# FAQ

> Frequently asked questions about CareerOS (product + engineering).
> **Owner:** All contributors · **Last reviewed:** on approval · **Status:** Living

## 1. Purpose
Capture recurring questions and their canonical answers so the same thing isn't re-explained, and link to the authoritative doc for each.

## 2. Contents
- Product questions (what it is, who it's for, CRI, versions).
- Engineering questions (setup, running tests, adding a module, migrations).
- Contribution/process questions.
- Each answer links to the source-of-truth doc.

## 3. Standard Template
```markdown
# FAQ
> <one-line FAQ summary>
## Product
### Q: <question>
A: <short answer> — see [DOC](link).
## Engineering
### Q: <question>
A: <short answer> — see [DOC](link).
## Contributing
### Q: <question>
A: <short answer> — see [DOC](link).
```

## 4. Suggested Sections
Grouped by audience: **Product · Engineering · Contributing** (add more groups as needed).

## 5. Best Practices
- One question per entry; answer in 1–3 sentences, then link.
- Promote an answer here only after it's been asked more than once.
- Keep answers in sync with the linked source; if they conflict, the source wins.

## 6. Seed entries
**Product**
- *What is CareerOS?* An AI-powered Career Intelligence Platform — see [`PRODUCT.md`](PRODUCT.md).
- *What is the CRI?* The Career Readiness Index, a weighted 0–100 readiness score — see [`GLOSSARY.md`](GLOSSARY.md) / doc 17.
- *What's in V1 vs V2/V3?* See [`ROADMAP.md`](ROADMAP.md) and doc 17.

**Engineering**
- *How do I run it locally?* See [`DEVELOPMENT.md`](DEVELOPMENT.md).
- *How do I add a module?* Follow the module convention — see [`ARCHITECTURE.md`](ARCHITECTURE.md) + doc 02 §2.8.
- *How do I change the schema?* Via an Alembic migration — see [`DATABASE.md`](DATABASE.md).
- *How do I run tests / what must pass?* See [`TESTING.md`](TESTING.md).

## 7. Maintenance
- **Owner:** all contributors. **Trigger:** a question asked ≥ twice.
- **Cadence:** pruned each milestone (remove stale, merge duplicates).
