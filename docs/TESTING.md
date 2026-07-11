# TESTING

> Testing strategy, quality gates, and coverage expectations for CareerOS.
> **Owner:** QA Lead · **Last reviewed:** on approval · **Status:** Stable

## 1. Purpose
Define what "tested" means at every level so quality is enforceable in CI and no change merges untested.

## 2. Contents
- The test pyramid (unit → integration → API/contract → UI → E2E) and where each runs.
- Coverage targets and non-regression policy.
- Accessibility, security, and performance testing.
- Test data, fixtures, and environment strategy.
- Quality gates that block merges.
- **Source of truth:** [`12-testing-strategy.md`](12-testing-strategy.md).

## 3. Standard Template
```markdown
# TESTING
> <one-line testing summary>
## Test Pyramid
## Unit Tests
## Integration Tests
## API / Contract Tests
## UI / Component Tests
## E2E Tests
## Accessibility Testing
## Security Testing
## Performance Testing
## Coverage & Non-Regression
## Test Data & Fixtures
## Quality Gates (CI)
```

## 4. Suggested Sections
Test pyramid · Unit · Integration · API/contract · UI/component · E2E · Accessibility · Security · Performance · Coverage/non-regression · Test data · Quality gates.

## 5. Best Practices
- Test behavior, not implementation; domain rules (CRI, funnel transitions, revision scheduling) get first-class unit tests.
- Each module ships its golden-journey E2E before "done" (Definition of Done, doc 16 §1.2).
- Never modify a test just to make it pass; fix the code or the test's intent explicitly.
- Deterministic tests; no reliance on live third-party/LLM calls (mock at the seam).

## 6. Maintenance
- **Owner:** QA Lead. **Trigger:** new module, new quality gate, flaky-test policy change.
- **Cadence:** reviewed each milestone.
- **Process:** gate changes update this doc + CI config together.
