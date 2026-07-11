# ROADMAP

> Product/engineering roadmap and version boundaries for CareerOS.
> **Owner:** Product + CTO · **Last reviewed:** on approval · **Status:** Stable (V1 frozen)

## 1. Purpose
Communicate what is being built, in what order, and in which version (V1/V2/V3) — so scope stays disciplined and everyone shares one plan.

## 2. Contents
- The 12 delivery milestones (M1–M12) with objectives and exit criteria.
- V1/V2/V3 version boundaries and rationale.
- Dependency graph (phase ordering).
- Deferred ideas backlog (V2/V3) so nothing is lost or silently pulled into V1.
- **Source of truth:** [`14-development-roadmap.md`](14-development-roadmap.md) (phases) + [`17-architecture-freeze-report.md`](17-architecture-freeze-report.md) (version scopes).

## 3. Standard Template
```markdown
# ROADMAP
> <one-line roadmap summary>
## Now (current milestone)
## Next (upcoming milestones)
## Later (V2 / V3)
## Milestones M1–M12
## Version Boundaries (V1 / V2 / V3)
## Dependency Graph (Mermaid)
## Deferred Backlog
```

## 4. Suggested Sections
Now / Next / Later · Milestones M1–M12 · Version boundaries · Dependency graph · Deferred backlog.

## 5. Best Practices
- Keep it honest: "Now/Next/Later," not dates you can't hit; sequence over precise durations.
- Every roadmap item traces to a backlog epic (doc 17 §17.4).
- V1 scope does not grow — new ideas land in the deferred backlog (V2/V3).
- Update the moment priorities change; stale roadmaps erode trust.

## 6. Maintenance
- **Owner:** Product + CTO. **Trigger:** priority/scope change, milestone completion.
- **Cadence:** reviewed each milestone.
- **Process:** scope changes require matching updates to `PRODUCT.md` and, if architectural, an ADR.
