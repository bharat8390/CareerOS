# CHANGELOG

> All notable, user-facing changes to CareerOS.
> **Owner:** Release manager (all contributors add entries) · **Status:** Living
> Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) · Versioning: [SemVer](https://semver.org/)

## 1. Purpose
Provide a human-readable, chronological record of what changed in each release so users and engineers can understand upgrades without reading the git log.

## 2. Contents
- An `Unreleased` section accumulating merged changes.
- One section per released version (newest first), dated, grouped by change type.
- Links comparing versions (git tags) once a remote exists.
- **Source of truth for narrative releases:** [`RELEASES.md`](RELEASES.md).

## 3. Standard Template
```markdown
# Changelog
All notable changes to this project are documented here.
The format is based on Keep a Changelog; this project adheres to SemVer.

## [Unreleased]
### Added
### Changed
### Deprecated
### Removed
### Fixed
### Security

## [X.Y.Z] - YYYY-MM-DD
### Added
- <user-facing change> (#PR)
```

## 4. Suggested Sections
`Unreleased` first, then released versions newest-first. Within each: **Added / Changed / Deprecated / Removed / Fixed / Security**.

## 5. Best Practices
- Write entries for **humans**, describing user impact — not commit messages.
- Add the entry in the **same PR** as the change (reviewers check for it).
- One line per change with a PR/issue link; group by type; keep newest on top.
- Move `Unreleased` items under a version + date at release time.

## 6. Maintenance
- **Owner:** Release manager; **every contributor** appends under `Unreleased`.
- **Trigger:** any user-facing change. **Cadence:** continuous; finalized at each release.
- **Automation (planned):** CI check that user-facing PRs touch this file.

---

## [Unreleased]
### Added
- Documentation set established (OSS-style `/docs`: PRODUCT, ARCHITECTURE, DATABASE, API, DEVELOPMENT, DEPLOYMENT, TESTING, SECURITY, CONTRIBUTING, CHANGELOG, RELEASES, ROADMAP, FAQ, GLOSSARY, ADRs).
- Architecture frozen for V1 (see doc 17).

_No code released yet — implementation begins at M1 (Foundations) after approval._
