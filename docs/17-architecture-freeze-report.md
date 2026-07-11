# 17 — Final Architecture Freeze Report

> **Status:** FINAL ARCHITECTURE REVIEW — no code, no redesign.
> **Author:** CTO / CPO / Solution Architect (CareerOS).
> **Purpose:** Classify all 33 proposed improvements into V1/V2/V3, size them, and
> freeze the official blueprint. After this report, **no further architecture
> changes should be required** to begin implementation.
> **Prime directive:** *Prevent over-engineering.* V1 must be completable by **one
> engineering student building this alongside placement prep**, maximizing
> **Resume · Interview · Placement · Portfolio** value — without sacrificing completion.

---

## 17.0 CTO thesis (how decisions were made)

Three tests decide the version of every improvement:

1. **Placement-critical?** Does it directly help the student get interview-ready and secure an offer *this season*? → V1.
2. **Buildable-solo without AI/infra risk?** Can it ship deterministically (no LLM ops, no distributed systems) in ≤ a few days? → eligible for V1.
3. **Showcase leverage per hour?** Does it demonstrate product/engineering skill cheaply (ADRs, journals, portfolio mode, feature flags)? → cheap ones pulled into V1; expensive "intelligence" deferred to V2.

**Consequences:**
- V1 = a **complete, deterministic Career Intelligence tracker** with a real CRI, analytics, funnels, portfolio mode, and engineering hygiene (ADRs, flags, journal). It is demoable end-to-end and looks senior.
- **All LLM/ML "intelligence"** (Mentor, Prediction, Skill/Company/Project intelligence, AI roadmap) → **V2**, behind the AI Gateway, so V1 never depends on an LLM being available, funded, or safe.
- **Commercial/multi-tenant** surface (recruiter/college portals, marketplace, billing, salary prediction) → **V3**.

> Deliberate anti-over-engineering cuts in V1: no Kafka, no microservices, no k8s, no OAuth-everything, no real-time ML. Modular monolith + Postgres + Redis + one worker. Everything else is a clean seam for later.

---

## 17.1 Classification of all 33 improvements

**Complexity** = build difficulty for a solo student. **Effort** = ideal engineering days (solo, incl. tests + docs). **Value** columns: B=Business, R=Resume, P=Placement, E=Engineering (H/M/L).

| # | Improvement | Ver | Cx | Effort | Depends on | B | R | P | E |
|---|-------------|-----|----|--------|-----------|---|---|---|---|
| 1 | Career Intelligence Platform (reframe: predict→track→recommend→improve→prepare→secure) | **V1** | Low | 0.5d (framing) | — | H | H | H | M |
| 2 | **Career Readiness Index (CRI)** (deterministic, weighted pillars) | **V1** | Med | 4d | activity modules | H | H | H | H |
| 3 | Skill Intelligence Engine (multi-dim + market demand + AI rec) | **V2** | High | 6d | 2, AI Gateway | M | H | M | H |
| 4 | Career Heatmap (viz of CRI/skill sub-scores) | **V1** | Low | 1.5d | 2 | M | H | M | M |
| 5 | Company Matching Engine | **V2** | High | 6d | CRM, CRI, AI | H | H | H | H |
| 6a | Resume Intelligence — **ATS score + keyword analysis + resume analytics** (deterministic) | **V1** | Med | 4d | Resume module | H | H | H | M |
| 6b | Resume Intelligence — role/company-specific tailoring (LLM) | **V2** | Med | 3d | 6a, AI | M | H | H | M |
| 7 | AI Career Mentor (daily planner, weekly review, weak-area, motivation) | **V2** | High | 7d | AI Gateway, analytics | H | H | H | H |
| 8 | Placement Prediction Engine (interview/offer probability) | **V2** | High | 5d | CRI, funnel history, AI/ML | H | H | H | H |
| 9 | Placement Analytics Dashboard (application/interview/offer funnels, success rate, monthly) | **V1** | Med | 3d | Applications, Interviews | H | H | H | M |
| 10a | Interview Intelligence — **track questions/mistakes/lessons/confidence** | **V1** | Low | 2d | Interviews | M | H | H | M |
| 10b | Interview Intelligence — pattern detection | **V2** | Med | 2d | 10a, AI | M | M | M | M |
| 11a | Smart Weekly Review — **templated summary + manual reflection** | **V1** | Low | 1.5d | analytics | M | M | M | L |
| 11b | Smart Weekly Review — **AI-generated** summary/suggestions | **V2** | Med | 2d | 11a, AI | M | M | M | M |
| 12 | Smart Goal Engine (measurable, role-linked goals) | **V1** | Low | 2d | Roadmap | M | M | H | M |
| 13a | Learning Recommendation — **rule-based** (revision-due, next-topic-by-order) | **V1** | Low | 1.5d | Learning | M | M | M | M |
| 13b | Learning Recommendation — **AI** (personalized) | **V2** | Med | 3d | 13a, AI | M | H | M | H |
| 14a | Project Intelligence — **self-eval fields** (resume value, difficulty, docs) | **V1** | Low | 1.5d | Projects | M | H | M | L |
| 14b | Project Intelligence — **AI evaluation** | **V2** | Med | 3d | 14a, AI | M | H | M | M |
| 15a | GitHub Intelligence — **sync repos/commits/streak/activity** | **V1** | Med | 3d | Projects, GitHub OAuth | M | H | M | H |
| 15b | GitHub Intelligence — **repo-health/doc scoring** | **V2** | Med | 2d | 15a | L | M | L | M |
| 16 | LinkedIn Intelligence — **manual profile completeness + networking log** | **V1** | Low | 1.5d | Profile | L | M | M | L |
| 16b | LinkedIn engagement analytics (API-limited) | **V3** | High | — | partnerships | L | L | L | L |
| 17 | Career Dashboard (answers: where am I / do next / pending / weak / target) | **V1** | Med | 3d | 2,4,9 | H | H | H | M |
| 18 | Gamification (achievements, badges, learning/coding/interview streaks) | **V1** | Low | 2d | activity events | M | M | M | M |
| 19 | AI Roadmap Generator (role/timeline/skill-level) | **V2** | High | 5d | Roadmap, AI | H | H | H | H |
| 20 | Personal Career CRM (recruiters, mentors, referrals, networking, follow-ups) | **V1** | Med | 3d | Company CRM | M | M | H | M |
| 21 | Notifications Engine (in-app + email: deadlines, revision, applications, interviews) | **V1** | Med | 3d | scheduler | M | M | H | M |
| 22a | Analytics Engine — **charts/heatmaps/skill·resume·github growth** | **V1** | Med | 3d | activity modules | H | H | M | M |
| 22b | Analytics Engine — advanced cohort/interview analytics | **V2** | Med | 2d | 22a | M | M | M | M |
| 23 | Future AI Architecture (Gateway: reviewer, mock interview, coach, sprint gen, matcher, project reviewer) | **V2** | High | (design in V1, build V2) | — | H | H | M | H |
| 23s | Salary Predictor | **V3** | High | — | market data | M | M | M | M |
| 24 | Product Evolution (V1/V2/V3 doc) | **V1** | Low | 0.5d | — | M | M | L | L |
| 25 | Agile Project Management Module (CareerOS manages its own dev: backlog, sprint, Kanban, story points, velocity, releases, dependencies) | **V2** | High | 6d | Sprint module | M | **H** | L | **H** |
| 26 | Developer Mode (dev dashboard: sprint, branch, build, CI/CD, tests, coverage, tech debt, deployment) | **V2** | High | 5d | 25, CI integration | M | **H** | L | **H** |
| 27 | Engineering Analytics (features, API count, components, coverage, bugs, velocity, tech debt) | **V2** | Med | 3d | 25/26 | M | **H** | L | **H** |
| 28 | **Architecture Decision Records (ADR)** | **V1** | Low | ongoing (0.5d setup) | — | M | **H** | L | **H** |
| 29 | **Portfolio Mode** (recruiter-facing public profile: projects, skills, resume, CRI, GitHub, timeline, achievements) | **V1** | Med | 4d | most V1 modules | **H** | **H** | **H** | M |
| 30 | **Feature Flag System** (experimental/AI/beta gating) | **V1** | Low | 1.5d | config | M | M | L | **H** |
| 31 | System Health Dashboard (frontend/backend/db/api/scheduler/queues/storage/auth/deploy) | **V2** | Med | 3d | observability | L | M | L | **H** |
| 32 | **Developer Journal** (daily eng log: problems/solutions/learning/next) | **V1** | Low | 1d | — | L | **H** | L | M |
| 33 | **Learning Journal** (daily learning, reflection, revision, resources, weak areas) | **V1** | Low | 1.5d | Learning | M | M | M | L |

**Totals — V1 net new effort** (beyond the base 12-phase modules): ~**55–60 engineering days** of *additional* work spread across the existing milestones. This is realistic for a student over a placement-season timeline because most V1 items are **low-complexity, deterministic extensions** of modules already planned in doc 14.

---

## 17.2 Business / Resume / Placement / Engineering value (narrative for the decisive calls)

- **CRI (2)** — the product's spine and the single most interview-worthy artifact ("I designed a weighted, explainable readiness index"). V1, deterministic; ML tuning is V2.
- **Portfolio Mode (29)** — highest ROI for a student: a **public recruiter-facing page** is directly usable in the actual job hunt (placement + resume value) and demonstrates product thinking. Promoted to V1.
- **ADR (28) + Developer Journal (32) + Feature Flags (30)** — cheap, ongoing, and disproportionately raise the *engineering-maturity* signal recruiters and interviewers respond to. V1.
- **Agile PM / Developer Mode / Engineering Analytics (25–27)** — genuinely impressive ("the app manages its own development") and high resume/engineering value, **but not placement-critical and high-complexity**. Deferring to V2 protects V1 completion — the #1 risk. A lightweight stand-in (a simple Kanban for personal tasks + the Developer Journal) covers the need in V1.
- **All LLM intelligence (3,5,7,8,13b,14b,19, AI in 6b/10b/11b/23)** — highest wow-factor but adds provider cost, prompt/guardrail/eval work, and non-determinism. Concentrated in **V2** behind the AI Gateway so V1 is robust and free to run. The **AI Gateway interface is designed (not built) in V1** so V2 slots in without rework.
- **Commercial surface (16b, 23s salary, recruiter/college portals, marketplace, billing)** — **V3**; irrelevant to one student's placement and requires multi-tenant/partnership investment.

---

## 17.3 Architecture Change Log (freeze deltas vs docs 01–16)

Additive only — no redesign. "New seam" = interface added now, implemented later.

| Area | Change | Version | Notes |
|------|--------|---------|-------|
| Philosophy | Reframe to Career Intelligence Platform loop | V1 | Doc 15 §15.0 adopted |
| Metric | `employability_scores` → `readiness_scores`; CRI = weighted pillars | V1 | Already applied (docs 03/04); V1 pillars: learning, coding, projects, resume, github, applications, interviews, communication(manual), consistency, certification(manual), linkedin(manual) |
| DB (V1 new) | `journals` (type: developer/learning), `goals` (already), `achievements`(already), `portfolio_settings`, `feature_flags`, `interview_questions`(+mistake/lesson/confidence), `contacts`+`interactions` (Career CRM), `resume_analytics` | V1 | All tenant-scoped, UUID PK, TIMESTAMPTZ; extend doc 04 |
| DB (V2 new) | `skills`, `user_skills`, `company_profiles`, `company_match_snapshots`, `project_evaluations`, `prediction_snapshots`, `ai_interactions`(already), `eng_metrics`, `dev_sprints/backlog_items` | V2 | Added at V2 start; seams reserved now |
| API (V1) | Add `/me/journals`, `/me/goals`, `/me/achievements`, `/me/portfolio` (+ public `/p/{handle}`), `/me/resumes/{id}/ats-scan`, `/me/analytics/funnels`, `/me/career-readiness-index` (already) | V1 | Extends doc 05 catalog |
| API (V2) | `/me/ai/*`, `/me/skills`, `/me/company-matches`, `/me/predictions`, `/dev/*` (agile/eng analytics), `/system/health` | V2 | Behind feature flags |
| Modules | New V1 modules: `journal`, `portfolio`, `crm-contacts`; `feature_flags` in `core` | V1 | Follow standard module convention (doc 02 §2.8) |
| Modules | New V2 modules: `skill`, `matching`, `prediction`, `ai` (build-out), `devops`(agile/eng analytics/health) | V2 | Extraction-ready seams |
| Navigation | V1: add **Portfolio**, **Journal** (Dev+Learning), **Goals & Achievements**; introduce **Mode switch (Career / Developer)** shell — Developer Mode content is V2, the toggle affordance is V1-stubbed | V1/V2 | Doc 06 nav extended |
| Dashboard | Career Dashboard answers 5 questions (17); add Heatmap widget (4) + funnel widgets (9) | V1 | Deterministic |
| Cross-cutting | Feature-flag gate around every V2/AI surface; AI Gateway interface stub | V1 | Enables safe incremental rollout |
| Infra | No change to V1 topology (modular monolith + Postgres + Redis + 1 worker). Microservices/k8s remain V3 posture | — | Anti-over-engineering |

---

## 17.4 Implementation Backlog (V1 epics → representative stories)

Ordered within the doc-14 milestones. Each story ships with tests + docs (Definition of Done, doc 16 §1.2).

**EPIC A — Foundations & hygiene (M1)**
- A1 Monorepo + tooling + CI; A2 App factory + health/ready + error envelope; A3 Web shell + tokens + light/dark; A4 Postgres + Alembic baseline; A5 Docker Compose; **A6 Feature-flag system (30)**; **A7 ADR framework + first ADRs (28)**.

**EPIC B — Identity (M2)**
- B1 Register/login/refresh/logout; B2 RBAC + ownership; B3 Profile CRUD; B4 OAuth (Google/GitHub); B5 rate-limit + audit.

**EPIC C — Shell, CRI v0, Career Dashboard (M3)**
- C1 Nav + command palette + **Career/Developer mode toggle (stub)**; C2 Onboarding wizard; **C3 CRI engine v0 (2)**; **C4 Career Dashboard answering 5 questions (17)**; C5 analytics_snapshots plumbing.

**EPIC D — Learning + journals (M4)**
- D1 Taxonomy seed; D2 Topic progress; **D3 Learning Journal (33)**; **D4 rule-based revision/next-topic recs (13a)**; D5 learning sub-score; D6 learning dashboard.

**EPIC E — Coding (M5)**
- E1 Problems CRUD; E2 streak/heatmap; E3 coverage radar + revisit; E4 coding sub-score; **E5 coding streak → gamification (18)**.

**EPIC F — Projects + GitHub (M6)**
- F1 Projects/milestones/tasks Kanban; **F2 Project self-eval fields (14a)**; **F3 GitHub OAuth + sync repos/commits/streak (15a)**; F4 project/github sub-scores.

**EPIC G — Companies + CRM + LinkedIn (M7)**
- G1 Companies CRUD + search; **G2 Personal Career CRM: contacts/mentors/referrals/follow-ups (20)**; **G3 LinkedIn manual completeness + networking log (16)**; G4 company dashboard.

**EPIC H — Applications + funnels (M8)**
- H1 Applications CRUD + funnel Kanban; H2 status transition rules; H3 deadlines + **Notifications Engine (21)**; **H4 Placement Analytics funnels + success rate + monthly (9, 22a)**; H5 application sub-score.

**EPIC I — Interviews + Resume/ATS (M9)**
- I1 Interviews (rounds/feedback/outcomes); **I2 Interview Intelligence tracking (10a)**; I3 Resume Studio (versions/sections); **I4 deterministic ATS + keyword analysis + resume analytics (6a)**; I5 PDF export.

**EPIC J — Analytics, CRI v1, gamification, goals, portfolio (M10)**
- J1 Polish 8 dashboards; **J2 CRI v1 (role-weighted, trend, biggest-lever) (2)**; **J3 Career Heatmap (4)**; **J4 Smart Goal Engine (12)**; **J5 Achievements/badges/streaks (18)**; **J6 Templated Smart Weekly Review (11a)**; **J7 Portfolio Mode + public profile (29)**; **J8 Developer Journal surfaced (32)**.

> V1 ends at M10 for feature completeness; M11 (AI) and M12 (hardening/GA) proceed as V2 build + productionization.

---

## 17.5 Engineering Priority Matrix

| Priority | Definition | Items |
|----------|-----------|-------|
| **Critical** | V1 cannot ship / demo without it | Foundations (A), Auth (B), CRI (2), Career Dashboard (17), Applications+funnels (8/9), Resume+ATS (6a), Learning (M4), Coding (M5), Interviews (I1/10a) |
| **High** | Major placement/resume/portfolio value, V1 | Portfolio Mode (29), Analytics/Heatmap (4/22a), Projects+GitHub (14a/15a), Career CRM (20), Notifications (21), Goals (12), Gamification (18), ADR (28), Feature Flags (30) |
| **Medium** | Nice in V1 / core of V2 intelligence | Journals (32/33), Weekly Review templated (11a), rule recs (13a), LinkedIn manual (16); V2: Skill/Company/Project intelligence, Mentor, Prediction, AI Roadmap, Agile PM, Developer Mode, Eng Analytics, System Health |
| **Low** | Deferred / commercial / speculative | LinkedIn engagement (16b), Salary predictor (23s), recruiter/college portals, marketplace, billing (all V3) |

---

## 17.6 FINAL MVP SCOPE — Version 1 (before placement season)

**Theme:** *A complete, deterministic Career Intelligence tracker that a student actually uses to get placed — and shows off as a portfolio piece.*

Included:
- Auth + profile + RBAC; onboarding (target role, timeline, domains).
- **CRI** (deterministic, explainable) + **Career Heatmap** + **Career Dashboard** (answers the 5 questions).
- **Learning** (taxonomy, progress, rule-based revision/next-topic, Learning Journal).
- **Coding** (tracker, streaks, heatmap, coverage).
- **Projects** (Kanban + self-eval) + **GitHub sync** (repos/commits/streak).
- **Companies + Personal Career CRM** (contacts/mentors/referrals/follow-ups) + **manual LinkedIn** tracking.
- **Applications** (funnel + transition rules + deadlines) + **Placement Analytics** (application/interview/offer funnels, success rate, monthly).
- **Interviews** (rounds/feedback + Interview Intelligence tracking) + **Resume Studio** (versions, **deterministic ATS + keyword analysis + resume analytics**, PDF export).
- **Goals**, **Gamification** (achievements/streaks), **templated Weekly Review**.
- **Portfolio Mode** (public recruiter-facing profile).
- **Notifications** (in-app + email reminders).
- Engineering hygiene: **ADRs**, **Developer Journal**, **Feature Flags**, health/ready, CI/CD, tests.

Explicitly excluded from V1 (deferred, with seams reserved): all LLM/ML features, Agile PM/Developer Mode/Engineering Analytics, System Health dashboard, company matching, prediction, AI roadmap/mentor, skill intelligence, multi-tenant/commercial.

**Why:** every included item is placement-usable, deterministic, solo-buildable, and collectively demonstrates product + software + data + analytics + system-design skill. Nothing here can be blocked by an LLM outage, cost, or safety review.

---

## 17.7 Version 2 Scope — Intelligence & Automation

**Theme:** *Turn the tracker into an intelligent coach.* Everything runs behind the **AI Gateway** + **feature flags**.
- **Skill Intelligence Engine** (multi-dim, market demand, AI recommendations).
- **AI Career Mentor** (daily planner, AI weekly review, weak-area detection, motivation).
- **Placement Prediction Engine** (interview/offer probability + confidence).
- **Company Matching Engine**; **AI Roadmap Generator**.
- AI upgrades to Resume (6b), Interview patterns (10b), Learning recs (13b), Project eval (14b), Weekly review (11b); GitHub repo-health (15b); advanced analytics (22b).
- **Agile Project Management Module (25)** + **Developer Mode (26)** + **Engineering Analytics (27)** + **System Health Dashboard (31)** — the "CareerOS builds CareerOS" showcase.
- Full **Future AI Architecture (23)**: reviewer, mock interview, coach, sprint generator, project reviewer.
- Multi-user platform foundation (shared roadmaps, beta features).

**Why:** these maximize intelligence/wow but carry cost, non-determinism, and ops burden — appropriate only once V1 is complete and real user data exists to ground models.

---

## 17.8 Version 3 Scope — Commercial SaaS

**Theme:** *Productize into a business.*
- College/Institution Admin dashboards, cohort analytics, SSO, bulk seats.
- Recruiter Portal + Portfolio discovery; Mentor Marketplace; Referral system.
- Subscription/billing plans; community features; Job Board integrations.
- **Salary Predictor (23s)**; ML-based interview prediction trained on accumulated prep→outcome data; LinkedIn engagement analytics (16b) via partnerships.
- Microservice extraction (AI/Analytics/Notifications/Integrations), Kafka, k8s/HA as scale demands.

**Why:** requires multi-tenancy, compliance, partnerships, and revenue infrastructure — irrelevant to a single student's placement and only justified by market traction.

---

## 17.9 Why each version boundary holds (summary)

- **V1 = placement-critical + deterministic + solo-sized.** Optimizes Resume/Interview/Placement/Portfolio value; guaranteed to finish.
- **V2 = intelligence/automation.** High value, high complexity/cost/non-determinism; needs V1 data + AI Gateway; gated by flags.
- **V3 = commercialization.** Multi-tenant, revenue, partnerships; a company, not a project.

---

## 17.10 Architecture Freeze Statement

The architecture is hereby **FROZEN** for implementation:

- **Style:** modular monolith (FastAPI) + Next.js, Postgres 16 (+pgvector reserved for V2), Redis, one worker; event-driven internals; API-first; extraction seams for AI/Analytics/Notifications/Integrations.
- **Scope:** V1 as defined in §17.6 is the build target; V2/V3 seams are reserved, not built.
- **Process:** trunk-based branching, Conventional Commits, ADRs, feature flags, quality gates from M1 (doc 16).
- **Guardrail:** any new idea after this report is triaged into V2/V3 backlog — **V1 scope does not grow.**

This report is the **official blueprint**. On approval, implementation begins at **M1 (Foundations)** per doc 16, as small reviewed PRs. No further architecture changes are anticipated.
