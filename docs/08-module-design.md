# 08 — Module Design

Each module documented with: **Purpose · Features · Inputs · Outputs · KPIs · Database Tables · API Dependencies · UI Components**.

---

## 8.1 Career Dashboard
- **Purpose:** Single command center orienting the student around the North-Star KPI (get placed) with today's plan and readiness at a glance.
- **Features:** Career Readiness Index ring + delta, today's tasks, application funnel widget, upcoming deadlines, streak, AI nudge, quick actions, score breakdown radar.
- **Inputs:** Aggregated data from all modules (score, tasks, applications, deadlines).
- **Outputs:** Prioritized daily view; entry points into every module.
- **KPIs:** Career Readiness Index, CRI 7-day delta, active-day streak, tasks completed today, days-to-target.
- **DB tables:** `readiness_scores`, `tasks`, `daily_tasks`, `applications`, `analytics_snapshots`, `notifications`.
- **API:** `GET /me/analytics/overview`, `/me/career-readiness-index`, `/me/tasks/today`, `/me/applications/funnel`, `/me/notifications`.
- **UI:** ScoreRingCard, TodaysTasksWidget, FunnelWidget, DeadlinesWidget, StreakWidget, AINudgeWidget, RadarChart, quick-add.

## 8.2 Learning (LMS)
- **Purpose:** Structured, role-aligned mastery of domains via topics/sub-topics with spaced revision.
- **Features:** Domain→topic→sub-topic hierarchy, progress & mastery tracking, confidence, notes, resource attachment, spaced-repetition revision, coverage view.
- **Inputs:** Curated taxonomy; user progress updates, notes, resources.
- **Outputs:** Mastery %, revision schedule, learning sub-score, coverage gaps.
- **KPIs:** Topics mastered, domain coverage %, avg mastery, revision adherence, weekly learning hours.
- **DB tables:** `learning_domains`, `topics`, `sub_topics`, `user_domains`, `topic_progress`, `revision_schedule`, `resources`, `topic_resources`.
- **API:** `/domains`, `/topics/{id}`, `/me/learning/progress`, `/me/topics/{id}/progress`, `/me/revision/due`.
- **UI:** Domain cards, ProgressRing, topic list w/ progress bars, notes editor, RevisionDueWidget, coverage chart.

## 8.3 Coding Tracker
- **Purpose:** Track DSA/coding practice consistency, coverage, and revisit needs.
- **Features:** Problem log (platform/difficulty/topic/status/time), streaks, calendar heatmap, topic & difficulty coverage, revisit queue.
- **Inputs:** Manually logged (or imported) problem entries.
- **Outputs:** Streak, heatmap, coverage radar, coding sub-score, revisit list.
- **KPIs:** Problems solved (total/weekly), current & longest streak, difficulty mix, topic coverage %, revisit backlog.
- **DB tables:** `coding_problems`, `topics`.
- **API:** `/me/coding/problems`, `/me/coding/heatmap`, `/me/coding/coverage`, `/me/coding/revisit`.
- **UI:** Heatmap calendar, RadarChart (coverage), DataTable (problems), revisit queue, quick-log dialog.

## 8.4 Projects
- **Purpose:** Plan and ship portfolio projects that prove role-relevant skills.
- **Features:** Project CRUD, milestones, Kanban tasks, tech stack, GitHub repo link, resume-bullet linkage, role relevance.
- **Inputs:** Project definitions, milestones/tasks, repo links.
- **Outputs:** Shipped projects, project sub-score, resume evidence.
- **KPIs:** Projects completed, milestones hit on time, role-relevance coverage, repos linked.
- **DB tables:** `projects`, `milestones`, `tasks`, `github_repositories`.
- **API:** `/me/projects`, `/me/projects/{id}/milestones`, `/me/projects/{id}/tasks`, `/me/projects/{id}/link-repo`.
- **UI:** EntityCard grid, KanbanBoard, Timeline (milestones), project detail, repo-link dialog.

## 8.5 Resume (ATS)
- **Purpose:** Maintain tailored, ATS-optimized resumes tied to target roles and portfolio reality.
- **Features:** Multiple versions, structured sections, drag-reorder, live preview, ATS scan (keyword gap vs role/JD), AI suggestions, PDF export, primary version.
- **Inputs:** Section content, target role/JD, portfolio data.
- **Outputs:** ATS score, keyword coverage, PDF, resume sub-score.
- **KPIs:** ATS score, keyword match %, versions per role, primary freshness.
- **DB tables:** `resume_versions`, `resume_sections`, `target_roles`, `embeddings`.
- **API:** `/me/resumes`, `/me/resumes/{id}/sections`, `/me/resumes/{id}/ats-scan`, `/me/resumes/{id}/export`.
- **UI:** Version list, section editor (RichTextEditor), live preview, ATS panel, export dialog.

## 8.6 GitHub
- **Purpose:** Turn coding activity into an objective, auto-updating portfolio signal.
- **Features:** OAuth connect, repo/activity sync, language breakdown, contribution heatmap, stars/commits stats, link repos to projects.
- **Inputs:** GitHub OAuth token; sync jobs.
- **Outputs:** Repo list, language chart, contribution stats, GitHub sub-score.
- **KPIs:** Public repos, commit frequency, languages aligned to role, contribution streak.
- **DB tables:** `github_repositories`, `projects`.
- **API:** `/me/github/connect`, `/me/github/sync`, `/me/github/repos`, `/me/github/stats`.
- **UI:** Repo cards, language DonutChart, contribution Heatmap, sync button/status.

## 8.7 LinkedIn
- **Purpose:** Track professional brand and networking activity (leading indicators of referrals).
- **Features:** Profile completeness tracking, connection/follower counts, networking activity log, nudges.
- **Inputs:** Profile URL/metrics (manual or limited API), logged activities.
- **Outputs:** Completeness %, networking cadence, LinkedIn sub-score.
- **KPIs:** Completeness %, connections growth, weekly networking actions, referral conversations.
- **DB tables:** `linkedin_profiles`, `networking_activities`.
- **API:** `/me/linkedin`, `/me/linkedin/activities`, `/me/linkedin/completeness`.
- **UI:** Completeness ProgressRing, networking log table, nudge cards.

## 8.8 Company CRM
- **Purpose:** Organize target companies and contacts like a sales pipeline.
- **Features:** Save companies with metadata, prioritize, contacts (recruiters/referrers), notes, search.
- **Inputs:** Company records, contacts, priorities.
- **Outputs:** Prioritized target list, contact directory feeding applications.
- **KPIs:** Companies saved, high-priority coverage, contacts/referrers per company.
- **DB tables:** `companies`, `company_contacts`, `applications`.
- **API:** `/me/companies`, `/me/companies/{id}/contacts`.
- **UI:** DataTable/cards, priority badges, contact drawer, search.

## 8.9 Applications
- **Purpose:** Track every application through the funnel with deadlines and follow-ups so nothing leaks.
- **Features:** Funnel Kanban (Saved→…→Accepted), deadlines, resume-version linkage, status transitions with rules, follow-up tasks, notes.
- **Inputs:** Company, role, dates, resume version, status changes.
- **Outputs:** Funnel state, deadline feed, application sub-score, conversion metrics.
- **KPIs:** Applications submitted, funnel conversion rates, offers, response rate, missed-deadline count.
- **DB tables:** `applications`, `companies`, `resume_versions`, `tasks`.
- **API:** `/me/applications`, `/me/applications/{id}/status`, `/me/applications/funnel`, `/me/applications/upcoming-deadlines`.
- **UI:** KanbanBoard (by status), DataTable, DeadlinesWidget, status-transition dialog.

## 8.10 Interviews
- **Purpose:** Track interview rounds, capture questions/feedback, and drive targeted improvement.
- **Features:** Rounds per application (type/mode/schedule), self-rating, outcome, feedback, per-round question bank, upcoming calendar.
- **Inputs:** Interview schedules, questions asked, feedback, ratings.
- **Outputs:** Interview history, personal question bank, interview sub-score, weak-area signals.
- **KPIs:** Interviews taken, pass rate by type, avg self-rating, questions logged, conversion to offer.
- **DB tables:** `interviews`, `interview_questions`, `applications`.
- **API:** `/me/applications/{id}/interviews`, `/me/interviews/{id}`, `/me/interviews/{id}/questions`, `/me/interviews/upcoming`.
- **UI:** CalendarView, round Timeline, question bank table, feedback form.

## 8.11 Sprint Planner
- **Purpose:** Time-box execution across all prep activities with a daily rhythm.
- **Features:** Sprints (goal/dates), Kanban board, backlog pull, AI auto-plan, daily view, burndown, weekly review integration.
- **Inputs:** Tasks (from learning/coding/projects/applications), roadmap milestones.
- **Outputs:** Sprint plan, daily task list, velocity, burndown.
- **KPIs:** Sprint completion %, velocity, daily task completion, planned-vs-done.
- **DB tables:** `sprints`, `tasks`, `daily_tasks`, `weekly_reviews`.
- **API:** `/me/sprints`, `/me/tasks`, `/me/tasks/today`, `/me/daily/plan`, `/me/weekly-reviews`, `/me/ai/sprint-plan`.
- **UI:** Sprint header, KanbanBoard, Burndown, daily list + focus timer, weekly-review form.

## 8.12 Analytics
- **Purpose:** Turn activity into insight across 8 dashboards and the Career Readiness Index.
- **Features:** Learning/Coding/Project/Placement/Company/Interview/Career/Overall dashboards; charts, rings, heatmaps, radar, funnels; trend lines; export.
- **Inputs:** All module data + score history + snapshots.
- **Outputs:** Dashboards, KPI cards, trends, funnels. (Detailed in doc 09.)
- **KPIs:** Career Readiness Index & sub-scores, funnel conversions, coverage, consistency.
- **DB tables:** `analytics_snapshots`, `readiness_scores`, plus source tables.
- **API:** `/me/analytics/*`, `/me/career-readiness-index`, `/me/career-readiness-index/history`.
- **UI:** Tabbed dashboards, MetricCards, all chart components.

## 8.13 AI Career Coach
- **Purpose:** Personalized, data-grounded guidance and practice to accelerate readiness.
- **Features:** Chat coach, resume review, mock interview, recommendations (learning/revision/project/company), weak-area detection, sprint auto-plan, interview prediction. (Detailed in doc 10.)
- **Inputs:** User context (score, gaps, funnel, history) via RAG.
- **Outputs:** Guidance, actionable cards (create task/sprint/revision), structured feedback, predictions.
- **KPIs:** Recommendation acceptance rate, AI-driven task completion, response ratings, CRI lift attributable to AI actions.
- **DB tables:** `ai_interactions`, `embeddings`, plus read access to source tables.
- **API:** `/me/ai/*`.
- **UI:** Chat UI, action cards, mock-interview runner, recommendation lists, prediction gauge.

## 8.14 Settings (supporting module)
- **Purpose:** Manage account, preferences, integrations, privacy.
- **Features:** Profile edit, theme, notification preferences, integrations (GitHub/LinkedIn), privacy/export/delete, 2FA.
- **DB tables:** `users`, `profiles`, `refresh_tokens`, preference blobs.
- **API:** `/me/profile`, `/me/settings/*`, `/me/export`, `/me/account`, `/auth/2fa/*`.
- **UI:** Settings tabs, toggles, integration cards, danger zone.

---

## 8.15 Career Readiness Index engine (cross-module)
- **Purpose:** Compute the North-Star KPI from weighted pillar sub-scores, role-weighted.
- **Formula (illustrative):**
  `CRI = Σ ( pillar_score × role_weight × pillar_weight )`, normalized 0–100, where pillars = {learning, coding, projects, resume, github, linkedin, applications, interviews}.
- **Pillar examples:** learning = f(mastery coverage, revision adherence); coding = f(problems solved, difficulty mix, streak, coverage); applications = f(volume, funnel progression); interviews = f(rounds, pass rate).
- **Role weighting:** `target_roles.skill_weights` shift emphasis (e.g., Data Engineer weights SQL/Python/ETL higher).
- **Recompute:** event-driven (on relevant domain events) + nightly full recompute; persisted to `readiness_scores` for trend.
- **Transparency:** breakdown surfaced in UI so students see *why* and *how to improve* (each pillar links to its module + "biggest lever" suggestion).
