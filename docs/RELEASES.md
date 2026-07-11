# RELEASES

> Release process, versioning policy, and per-release notes for CareerOS.
> **Owner:** Release manager · **Last reviewed:** on approval · **Status:** Stable

## 1. Purpose
Define how versions are cut and communicated, and hold the narrative release notes (the "why it matters" companion to the granular `CHANGELOG.md`).

## 2. Contents
- Versioning policy (SemVer) and what constitutes major/minor/patch.
- Release cadence and the cut/tag/deploy checklist.
- Per-release notes: highlights, upgrade/migration notes, known issues.
- Mapping of releases to product versions (V1/V2/V3) from `ROADMAP.md`.

## 3. Standard Template
```markdown
# RELEASES
> <one-line release-policy summary>
## Versioning Policy (SemVer)
## Release Cadence
## Release Checklist
## Release Notes
### vX.Y.Z — YYYY-MM-DD
- Highlights
- Upgrade / Migration Notes
- Known Issues
```

## 4. Suggested Sections
Versioning policy · Cadence · Release checklist · Release notes (per version) with highlights, upgrade/migration notes, known issues.

## 5. Best Practices
- SemVer strictly: breaking → major, feature → minor, fix → patch.
- Tag every release (`vX.Y.Z`); release notes link to the CHANGELOG range.
- Always include upgrade/migration notes when schema or config changes.
- Release notes are narrative (audience-facing); CHANGELOG is granular.

## 6. Release checklist (template)
1. `Unreleased` CHANGELOG finalized → versioned + dated.
2. Version bump + tag; migrations reviewed and reversible.
3. CI green; security/a11y/perf gates pass; preview→staging verified.
4. Deploy (blue-green); smoke test; monitor SLOs.
5. Publish release notes; announce; close the milestone.

## 7. Maintenance
- **Owner:** Release manager. **Trigger:** every release.
- **Cadence:** per release; policy reviewed each version cut.
- **Process:** notes drafted from the CHANGELOG diff during the release PR.
