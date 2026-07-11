# 09 — Analytics

Eight dashboards, each defined by **KPIs** and **chart specifications**. Data comes from live queries (recent) + `analytics_snapshots` (rollups) + `readiness_scores` (trend). Chart types: Progress Rings, Heatmaps, Radar, Line, Bar, Donut, Funnel, Sparkline, Gauge.

## 9.1 Analytics architecture
- **Live vs. precomputed:** dashboards read precomputed `analytics_snapshots` for expensive aggregates; recent/today figures computed live. Nightly + event-driven rollup jobs keep snapshots fresh.
- **Ranges:** each dashboard supports `7d / 30d / 90d / all` and custom range.
- **Export:** CSV/PNG export per chart; full report PDF.

---

## 9.2 Overall Dashboard
- **KPIs:** Career Readiness Index (+trend), days-to-target, active-day streak, offers, applications, interviews, tasks completed.
- **Charts:**
  - `Gauge/ProgressRing` — Career Readiness Index (0–100, color gradient).
  - `LineChart` — CRI trend over range.
  - `RadarChart` — 8 pillar sub-scores.
  - `FunnelChart` — application funnel.
  - `Heatmap` — daily activity (all modules combined).
  - `MetricCard` row — offers, apps, interviews, streak.

## 9.3 Learning Dashboard
- **KPIs:** topics mastered, domain coverage %, avg mastery, revision adherence, weekly learning hours.
- **Charts:**
  - `ProgressRing` per domain (mastery %).
  - `BarChart` — topics by status (not started/in progress/completed/needs revision) per domain.
  - `RadarChart` — domain coverage vs. role target.
  - `LineChart` — cumulative topics mastered over time.
  - `Heatmap` — study/revision activity.
  - Revision adherence `Gauge`.

## 9.4 Coding Dashboard
- **KPIs:** total & weekly problems solved, current/longest streak, difficulty mix, topic coverage, revisit backlog.
- **Charts:**
  - `Heatmap` — daily solved (LeetCode-style calendar).
  - `DonutChart` — easy/medium/hard distribution.
  - `RadarChart` — topic coverage.
  - `LineChart` — cumulative solved / weekly velocity.
  - `BarChart` — problems by platform.
  - Streak `MetricCard` with sparkline.

## 9.5 Project Dashboard
- **KPIs:** projects completed vs. in-progress, milestones on-time %, role-relevance coverage, repos linked.
- **Charts:**
  - `BarChart` — projects by status.
  - `Timeline` — milestone completion.
  - `ProgressRing` — portfolio completeness vs. role expectation.
  - `DonutChart` — tech-stack distribution.

## 9.6 Placement Dashboard
- **KPIs:** applications submitted, funnel conversion rates, offers, response rate, avg time-in-stage, missed deadlines.
- **Charts:**
  - `FunnelChart` — Saved→Applied→OA→Interview→Offer→Accepted with conversion % between stages.
  - `BarChart` — applications per week.
  - `LineChart` — cumulative applications & offers.
  - `Gauge` — response rate.
  - Deadline adherence `MetricCard`.

## 9.7 Company Dashboard
- **KPIs:** companies saved, high-priority coverage, applications per company, referrals secured.
- **Charts:**
  - `BarChart` — companies by priority / industry.
  - `DonutChart` — source mix (campus/referral/portal).
  - `Table` — top target companies with stage.

## 9.8 Interview Dashboard
- **KPIs:** interviews taken, pass rate by type, avg self-rating, questions logged, offer conversion.
- **Charts:**
  - `RadarChart` — performance by interview type (technical/behavioral/system design/HR).
  - `BarChart` — outcomes (passed/failed/pending) per round.
  - `LineChart` — avg self-rating over time.
  - Question-bank `MetricCard` + category `DonutChart`.

## 9.9 Career Dashboard (roadmap)
- **KPIs:** roadmap progress %, milestones completed, skill-gap vs. target role, days-to-target.
- **Charts:**
  - `ProgressRing` — roadmap completion.
  - `Timeline` — milestones (done/upcoming/overdue).
  - `RadarChart` — current skills vs. role-required skills (gap visualization).
  - `Gauge` — readiness for target role.

## 9.10 Offer Funnel (dedicated)
- **Purpose:** Explicit funnel + offer conversion analysis.
- **Charts:**
  - `FunnelChart` — full pipeline.
  - Stage-to-stage conversion `BarChart` (%).
  - `LineChart` — offers over time.
  - Leakage callouts (biggest drop-off stage highlighted).

## 9.11 Chart component ↔ KPI matrix

| Chart type | Where used |
|-----------|-----------|
| Progress Ring | Score, domain mastery, roadmap, portfolio completeness |
| Heatmap | Coding activity, learning activity, overall activity |
| Radar | Pillar sub-scores, topic coverage, interview performance, skill gap |
| Line | CRI trend, cumulative solved/apps/offers, ratings |
| Bar | Status distributions, per-week volumes, per-platform |
| Donut | Difficulty mix, tech stack, source mix, question categories |
| Funnel | Application funnel, offer funnel |
| Gauge | Response rate, revision adherence, readiness |
| Sparkline | Inline trends on MetricCards |

## 9.12 Insight & alerting layer
- **Auto-insights:** "Coding streak broke", "GitHub lagging vs. peers-target", "3 deadlines this week", "Interview pass rate dropped for system design".
- **Biggest-lever suggestion:** for the Career Readiness Index, compute which single action raises CRI most and surface it (feeds AI nudge + dashboard).
- **Delivery:** insights shown on dashboards and pushed via notifications/AI coach.
