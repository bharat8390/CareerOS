# 01 — Product Definition

Covers items 1–15: Executive Summary, Problem Statement, Vision, Mission, Business Goals, Target Users, User Personas, User Stories, Functional Requirements, Non-Functional Requirements, Feature List, Product Roadmap, Scope, Out of Scope, Technology Decisions.

---

## 1. Executive Summary

The **CareerOS — AI-Powered Career Intelligence Platform (Career Intelligence Platform)** is a multi-tenant SaaS platform that turns the chaotic, self-directed process of becoming placement-ready into a single, structured, data-driven workflow. It unifies capabilities that students today stitch together from a dozen disconnected tools — Notion (notes/planning), Jira (sprints/tasks), GitHub (code portfolio), LinkedIn (network/brand), LeetCode trackers (coding practice), a CRM (company outreach), an ATS resume checker, an AI career coach, and an LMS (structured learning).

Every activity a student logs — a topic mastered, a problem solved, a project shipped, a resume improved, an application submitted, an interview cleared — feeds a single composite **Career Readiness Index (CRI)**. The CRI is the product's heartbeat: it makes progress visible, drives personalized recommendations, and orients every screen toward the one outcome that matters: **securing a job offer before graduation.**

The system is designed enterprise-grade from day one: layered architecture, normalized relational data, a documented REST API, RBAC, encryption, CI/CD, containerized deploys, and a clear microservices extraction path. The AI layer is designed as an additive intelligence tier (coaching, resume review, mock interviews, recommendations, prediction) that consumes the same clean data model rather than a bolt-on.

**In one line:** *CareerOS is the operating system for a student's placement journey — plan, learn, build, apply, interview, and improve, all measured by one score.*

---

## 2. Problem Statement

Engineering and CS students preparing for placements face six compounding problems:

1. **Tool fragmentation.** Learning lives in YouTube/Notion, coding in LeetCode, projects in GitHub, applications in spreadsheets, networking in LinkedIn. Nothing is connected, so no one has a single view of readiness.
2. **No objective readiness signal.** Students cannot answer "Am I ready? For which role? What's my gap?" There is no measurable, trend-able indicator of employability.
3. **Unstructured preparation.** Effort is reactive and topic-hopping instead of a role-targeted roadmap with sprints, milestones, and spaced revision.
4. **Invisible application pipeline.** Applications, deadlines, referrals, OA rounds, and interview feedback are lost in inboxes and sheets. Follow-ups are missed; funnel leakage is invisible.
5. **Weak feedback loops.** Students don't know their weak areas, why they're rejected, or what to do next. Revision and improvement are guesswork.
6. **Portfolio–resume drift.** Resume claims, GitHub reality, and actual skills diverge, hurting both ATS pass-through and interviews.

The cost is real: late starts, wasted effort, missed deadlines, weak portfolios, and graduating unplaced.

---

## 3. Vision Statement

> **To become the default operating system every student uses to go from "enrolled" to "employed" — where preparation is structured, progress is measurable, and no capable student graduates unplaced for lack of a system.**

---

## 4. Mission Statement

> **We build an intelligent career operating system that helps engineering students become interview-ready and secure a placement before graduation** — by unifying learning, coding, projects, portfolio, networking, applications, and interviews into one workflow, and by converting every action into an actionable Career Readiness Index with AI-driven guidance.

---

## 5. Business Goals

| # | Goal | Metric / Target (illustrative) |
|---|------|-------------------------------|
| BG-1 | Improve placement outcomes | ≥ 20% higher offer rate for active users vs. baseline cohort |
| BG-2 | Drive engagement | ≥ 4 active days/week; ≥ 60% D30 retention |
| BG-3 | Make readiness measurable | 100% of active users have a live Career Readiness Index & trend |
| BG-4 | Reduce funnel leakage | ≥ 30% reduction in missed deadlines / dropped follow-ups |
| BG-5 | Monetize sustainably | Freemium → Pro conversion ≥ 5%; institutional (B2B2C) licensing |
| BG-6 | Scale reliably | 99.9% uptime; support 100k+ students on shared multi-tenant infra |
| BG-7 | Build defensible data | Proprietary dataset linking prep behavior → interview/offer outcomes (powers prediction) |

**Monetization model (context):** Free tier (core tracking + limited AI); **Pro** (full AI coach, unlimited resume/ATS scans, advanced analytics); **Institutional** (colleges/T&P cells: cohort dashboards, admin, bulk seats).

---

## 6. Target Users

- **Primary:** Computer Science students, IT students, and broader Engineering students actively preparing for campus/off-campus placements.
- **Secondary / near-term:** Fresh graduates in a job hunt.
- **Future:** Career switchers; college Training & Placement (T&P) cells and departments (B2B2C).

**Roles supported inside the product (career targeting):**
- *Primary roles:* Data Engineer, Data Analyst, Analytics Engineer, BI Developer, Data & Analytics Consultant.
- *Secondary roles:* AI Engineer, Python Developer, Backend Developer, Technical Business Analyst.

---

## 7. User Personas

### Persona A — "Aarav", the Focused Fresher (Primary)
- **Age/Context:** 21, pre-final-year CS, targets **Data Engineer**.
- **Goals:** A clear roadmap, daily plan, measurable progress, an interview-ready resume + portfolio.
- **Frustrations:** Too many tools, no idea if he's "ready", forgets revision, loses track of applications.
- **Needs:** Structured roadmap, sprint planner, coding tracker, resume/ATS, application CRM, CRI trend.
- **Success:** Offer letter for a Data Engineer role before graduation.

### Persona B — "Priya", the Late Starter (Primary)
- **Age/Context:** 22, final-year IT, started prep late, targets **Data Analyst / BI Developer**.
- **Goals:** Maximize limited time; prioritize highest-impact activities.
- **Frustrations:** Anxiety, unsure what to study first, weak areas unknown.
- **Needs:** AI recommendations ("what next"), weak-area detection, quick-win projects, deadline tracking.
- **Success:** Passes OAs and secures interviews within 8–10 weeks.

### Persona C — "Rahul", the Builder (Secondary)
- **Age/Context:** 23, fresh graduate, strong coder, targets **Backend / Python Developer**.
- **Goals:** Convert GitHub activity + projects into a compelling, ATS-passing narrative; mock interviews.
- **Frustrations:** Resume doesn't reflect skills; poor at behavioral interviews.
- **Needs:** GitHub sync, resume versioning + ATS, mock interview, interview tracker.
- **Success:** Multiple offers; picks the best.

### Persona D — "Dr. Menon", T&P Coordinator (Future / Institutional)
- **Context:** Manages a cohort of 300 students.
- **Goals:** Cohort readiness visibility, at-risk detection, company drive coordination.
- **Needs:** Admin dashboards, cohort analytics, bulk management, exports.
- **Success:** Higher department placement rate; earlier intervention for at-risk students.

---

## 8. User Stories

Format: *As a `<role>`, I want `<capability>` so that `<benefit>`.* (Grouped by epic; MoSCoW priority in brackets.)

**Onboarding & Roadmap**
- US-01 [Must] As a student, I want to select a target role so that my roadmap and recommendations are tailored.
- US-02 [Must] As a student, I want a generated career roadmap with milestones so that I know the path end-to-end.
- US-03 [Should] As a student, I want to set a graduation/target date so that plans are time-boxed against a deadline.

**Learning (LMS)**
- US-04 [Must] As a student, I want domains → topics → sub-topics with progress so that learning is structured.
- US-05 [Must] As a student, I want to mark mastery and attach resources/notes so that I track and revisit knowledge.
- US-06 [Should] As a student, I want spaced-revision reminders so that I retain what I learned.

**Coding Tracker**
- US-07 [Must] As a student, I want to log problems (platform, difficulty, topic, status) so that I track practice.
- US-08 [Should] As a student, I want a solving heatmap and topic coverage so that I see consistency and gaps.

**Projects**
- US-09 [Must] As a student, I want a project board with milestones/tasks so that I ship portfolio projects.
- US-10 [Should] As a student, I want to link projects to GitHub repos and resume bullets so that everything stays consistent.

**Resume (ATS)**
- US-11 [Must] As a student, I want multiple resume versions so that I tailor per role/company.
- US-12 [Must] As a student, I want an ATS score + keyword gap so that my resume passes screening.

**GitHub & LinkedIn**
- US-13 [Should] As a student, I want to sync GitHub repos/activity so that my portfolio auto-updates.
- US-14 [Should] As a student, I want to track LinkedIn profile completeness & networking so that I build my brand.

**Company CRM & Applications**
- US-15 [Must] As a student, I want to save companies and track applications through a funnel so that nothing is lost.
- US-16 [Must] As a student, I want deadline reminders and follow-up tasks so that I never miss an application.

**Interviews**
- US-17 [Must] As a student, I want to log interview rounds, questions, and feedback so that I learn from each.
- US-18 [Should] As a student, I want an AI mock interview so that I practice before the real thing.

**Sprint & Reviews**
- US-19 [Must] As a student, I want a sprint planner with tasks and a daily view so that I execute consistently.
- US-20 [Should] As a student, I want a weekly review so that I reflect and re-plan.

**Analytics & AI**
- US-21 [Must] As a student, I want an Career Readiness Index with trend so that I know my readiness.
- US-22 [Should] As a student, I want AI recommendations for "what to do next" so that I focus on high-impact work.
- US-23 [Could] As a student, I want interview-outcome prediction so that I know where I stand for a role.

**Notifications & Settings**
- US-24 [Must] As a student, I want reminders (deadlines, revision, sprint) so that I stay on track.
- US-25 [Must] As a user, I want to manage my profile, theme, and notification preferences.

**Admin / Institutional (Future)**
- US-26 [Could] As a T&P coordinator, I want cohort analytics and at-risk detection so that I intervene early.

---

## 9. Functional Requirements

| ID | Requirement |
|----|-------------|
| FR-01 | Users can register, verify email, log in, refresh sessions, reset passwords, and use OAuth (Google/GitHub). |
| FR-02 | Users select/switch a **target role**; the system maintains a **career roadmap** of milestones per role. |
| FR-03 | Learning module supports Domains → Topics → Sub-topics with per-item status, mastery %, notes, and attached resources. |
| FR-04 | Spaced-revision scheduling generates revision tasks based on mastery and last-reviewed dates. |
| FR-05 | Coding tracker records problems (title, platform, url, difficulty, topic, status, time, revisit flag) and computes streaks/heatmaps. |
| FR-06 | Projects module supports projects, milestones, and tasks (Kanban), with GitHub repo and resume-bullet linkage. |
| FR-07 | Resume module supports multiple versions, structured sections, target-role tagging, and an ATS score with keyword-gap analysis. |
| FR-08 | GitHub integration syncs repositories, languages, commit activity, and contribution stats. |
| FR-09 | LinkedIn module tracks profile completeness, connections, posts/activity, and networking tasks. |
| FR-10 | Company CRM lets users save companies with metadata (role, location, CTC band, source, contacts). |
| FR-11 | Applications track status through the funnel (Saved→Applied→OA→Interview→Offer→Accepted/Rejected) with dates, deadlines, and notes. |
| FR-12 | Interview module logs rounds, type, questions asked, self-rating, outcome, and feedback. |
| FR-13 | Sprint planner creates time-boxed sprints containing tasks spanning learning/coding/projects/applications; a Daily Tasks view aggregates today's items. |
| FR-14 | Weekly Review captures reflection, metrics snapshot, and next-sprint planning. |
| FR-15 | Analytics computes and stores KPIs and renders dashboards (learning, coding, project, placement, company, interview, career, overall). |
| FR-16 | **Career Readiness Index** is computed from weighted sub-scores and stored as a time series for trend analysis. |
| FR-17 | Notifications (in-app + email; push future) for deadlines, revision, sprint reminders, achievements, and AI nudges, respecting user preferences. |
| FR-18 | Achievements/gamification: badges, streaks, milestones tied to activity. |
| FR-19 | Goals: user-defined SMART goals with progress tracking, linked to activities. |
| FR-20 | AI layer provides career coaching, resume review, mock interview, learning/revision/project/company recommendations, weak-area detection, sprint auto-planning, and interview prediction. |
| FR-21 | Global search across entities (topics, projects, companies, applications, notes). |
| FR-22 | Data export (resume PDF, application CSV, full-account export for portability). |
| FR-23 | Admin functions: user management, content (domains/topics/roadmaps) management, feature flags, audit logs. |

---

## 10. Non-Functional Requirements

| Category | Requirement |
|----------|-------------|
| **Performance** | P95 API latency < 300ms for reads, < 600ms for writes (excluding third-party/AI calls). Dashboards render < 2s. |
| **Scalability** | Stateless services behind a load balancer; horizontal scale to 100k+ users; async workers for heavy/AI jobs. |
| **Availability** | 99.9% monthly uptime; graceful degradation when AI/third-party integrations are down. |
| **Reliability** | Idempotent write APIs where relevant; retries with backoff for integrations; dead-letter queues for failed jobs. |
| **Security** | OWASP Top 10 controls; encryption in transit (TLS 1.2+) and at rest (AES-256); secrets in a vault; RBAC. (See doc 11.) |
| **Privacy/Compliance** | GDPR-style data rights (export/delete); PII minimization; explicit consent for third-party sync; data residency-ready. |
| **Usability** | WCAG 2.1 AA accessibility; mobile-responsive; keyboard navigable; dark/light themes. |
| **Maintainability** | Layered, modular codebase; documented API (OpenAPI); ≥ 80% coverage on core domains; linting/typing enforced. |
| **Observability** | Structured logs, metrics, traces; error tracking; audit trail for sensitive actions; health/readiness endpoints. |
| **Portability** | Containerized; environment-agnostic via env vars; runs locally via Docker Compose and in cloud via orchestration. |
| **Internationalization** | i18n-ready (copy externalized); default English. |
| **Data integrity** | Referential integrity via FKs; transactional writes; soft-delete for user-recoverable entities. |
| **Cost** | AI calls rate-limited & cached; tiered feature gating to control per-user cost. |

---

## 11. Feature List (grouped)

**Core Workspace**
- Career Dashboard (Career Readiness Index, today's plan, funnel, alerts)
- Sprint Planner (sprints, tasks, daily view)
- Weekly Review
- Global search, command palette
- Notifications center

**Preparation**
- Learning (LMS): domains, topics, sub-topics, mastery, resources, notes, spaced revision
- Coding Tracker: problem log, streaks, heatmap, topic coverage, revisit queue
- Projects: Kanban board, milestones, tasks, GitHub/resume linkage

**Portfolio & Brand**
- Resume Studio: versions, sections, ATS score, keyword gap, PDF export
- GitHub: repo & activity sync, language/contribution stats
- LinkedIn: profile completeness, networking tracker

**Placement Pipeline**
- Company CRM: saved companies, contacts, notes
- Applications: funnel tracking, deadlines, follow-ups
- Interviews: rounds, questions, feedback, outcomes

**Intelligence**
- Analytics dashboards (8) with charts, rings, heatmaps, radar, funnels
- Career Readiness Index engine + trend
- AI Career Coach, Resume Review, Mock Interview, Recommendations, Weak-Area Detection, Sprint Auto-Plan, Interview Prediction

**Engagement & Account**
- Goals & Achievements (gamification)
- Settings (profile, theme, notifications, integrations, privacy)
- Data export / account portability

**Admin / Institutional (future)**
- Content management (domains/topics/roadmaps)
- Cohort dashboards, at-risk detection, bulk seat management, audit logs

---

## 12. Product Roadmap (product-level milestones)

> Engineering delivery phases are detailed in [doc 14](14-development-roadmap.md). This is the product/market view.

| Release | Theme | Highlights |
|---------|-------|-----------|
| **MVP (v0.1)** | "Track & Plan" | Auth, roadmap, learning, coding tracker, projects, sprint/daily, basic dashboard, Career Readiness Index v1. |
| **v0.2** | "Get Placed" | Company CRM, applications funnel, interviews, resume studio + ATS, notifications. |
| **v0.3** | "Portfolio & Insight" | GitHub & LinkedIn integration, full analytics suite, achievements/goals. |
| **v1.0** | "AI Career Coach" | AI coach, resume review, mock interview, recommendations, weak-area detection, interview prediction. |
| **v1.x** | "Institutional" | Cohort/admin dashboards, B2B2C licensing, SSO for colleges. |
| **v2.0** | "Marketplace & Community" | Mentor marketplace, peer cohorts, curated content, job board integrations. |

---

## 13. Scope (In Scope for v0.1–v1.0)

- Single-student multi-tenant SaaS (account = tenant).
- All 13 core modules (Dashboard, Learning, Coding, Projects, Resume, GitHub, LinkedIn, Company CRM, Applications, Interviews, Sprint, Analytics, AI Coach) + Settings.
- Career Readiness Index engine and time-series trend.
- Web application (responsive) with dark/light mode.
- REST API, PostgreSQL data layer, background workers, notifications (in-app + email).
- GitHub OAuth sync; LinkedIn manual/limited (API access restrictions acknowledged).
- AI features via managed LLM provider with caching and rate limits.
- CI/CD, containerized deployment, observability.

---

## 14. Out of Scope (for now)

- Native mobile apps (responsive web first; mobile is a fast follow, architecture is API-first to enable it).
- Full LinkedIn write/automation (against platform ToS; only compliant read/manual tracking).
- Real recruiter/job-board marketplace and live job ingestion (v2.0).
- Peer social network / messaging / community feed (v2.0).
- Payments/billing beyond basic subscription gating stub (integrate Stripe at monetization phase).
- Automated code execution/judging of coding problems (we track, not judge).
- Guaranteed placement or third-party job applications on the user's behalf.
- Non-English localization at launch (i18n-ready, but only English shipped).

---

## 15. Technology Decisions

> Rationale-driven. Choices favor a productive, hireable, well-supported stack with a clear scaling path. Alternatives noted.

| Layer | Decision | Why | Alternatives considered |
|-------|----------|-----|------------------------|
| **Frontend** | **React + TypeScript + Next.js**, **TailwindCSS**, **shadcn/ui + Radix**, **TanStack Query**, **Zustand** (light client state), **Recharts** (+ D3 for custom viz) | SSR/SSG for fast loads & SEO on public pages; huge ecosystem; strong typing; component primitives + Tailwind for a fast, consistent design system; TanStack Query for server-state caching. | Vue/Nuxt, SvelteKit, Angular |
| **Backend** | **Python 3.12 + FastAPI**, **Pydantic v2**, **SQLAlchemy 2.0 + Alembic**, **Uvicorn/Gunicorn** | Aligns with the product's data/AI domain and target roles (Python-heavy); FastAPI gives async performance, auto OpenAPI docs, and Pydantic validation; mature ORM + migrations. | Node/NestJS, Django REST, Go |
| **Async / Jobs** | **Celery** (or **ARQ**) with **Redis** broker; scheduled beats for reminders/score recompute | Offload AI calls, integrations, notifications, analytics rollups; retries + scheduling. | RQ, Dramatiq, cloud queues |
| **Primary DB** | **PostgreSQL 16** | Relational integrity for a highly-relational domain; JSONB for flexible fields; strong indexing; window functions for analytics. | MySQL, CockroachDB |
| **Cache / Rate-limit** | **Redis** | Sessions/optional, caching, rate limiting, Celery broker, leaderboards/streaks. | Memcached |
| **Search** | **Postgres FTS** at MVP → **OpenSearch/Elastic** later | Start simple; extract when search needs grow. | Meilisearch, Typesense |
| **Auth** | **JWT access + refresh** (httpOnly cookies), OAuth2 (Google/GitHub), TOTP 2FA; password hashing with **Argon2** | Stateless, scalable; OAuth reduces friction; strong hashing. | Session cookies + server store; Auth0/Clerk (managed option) |
| **AI Layer** | Managed **LLM provider** (OpenAI/Anthropic) behind an internal **AI Gateway** service; **pgvector** for embeddings/RAG | Fast to build, high quality; gateway centralizes prompts, caching, cost, and provider-swapping; pgvector avoids extra infra initially. | Self-hosted OSS models, dedicated vector DB (Pinecone/Weaviate) |
| **File storage** | **S3-compatible object storage** (resume PDFs, exports, avatars) | Durable, cheap, presigned URLs. | GCS, Azure Blob |
| **Email** | Transactional email provider (**Resend/SES/SendGrid**) | Reliable delivery for verification/reminders. | SMTP self-host |
| **Infra / Deploy** | **Docker**, **Docker Compose** (local), **Kubernetes** or managed PaaS (Render/Fly/ECS) for prod; **Terraform** IaC | Portable, reproducible; scale horizontally; IaC for repeatable envs. | Bare VMs, serverless-only |
| **CI/CD** | **GitHub Actions** | Native to GitHub-centric workflow; matrix tests, build, scan, deploy. | GitLab CI, CircleCI |
| **Observability** | **OpenTelemetry** traces, **Prometheus + Grafana** metrics, **Sentry** errors, structured JSON logs (Loki/ELK) | Full-stack visibility; standard tooling. | Datadog, New Relic |
| **Testing** | **pytest** (backend), **Vitest + React Testing Library** (frontend), **Playwright** (E2E), **Schemathesis** (API fuzz) | Coverage across the pyramid; contract testing from OpenAPI. | Jest, Cypress |

**Key architectural stance:** Start as a **modular monolith** (well-separated modules behind clean interfaces) to move fast, with the data/service boundaries drawn so that AI, analytics, notifications, and integrations can be **extracted into microservices** without rework (see doc 02).
