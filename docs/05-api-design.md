# 05 — API Design (REST)

**Base URL:** `/api/v1` · **Format:** JSON · **Auth:** Bearer JWT (access token) via `Authorization: Bearer <token>`; refresh token in httpOnly cookie. **Docs:** OpenAPI 3.1 auto-generated at `/api/docs`.

## 5.1 Conventions

- **Methods:** `GET` (read), `POST` (create), `PATCH` (partial update), `PUT` (replace), `DELETE` (remove/soft-delete).
- **Status codes:** `200` ok, `201` created, `204` no content, `400` validation, `401` unauthenticated, `403` forbidden, `404` not found, `409` conflict, `422` semantic validation, `429` rate limited, `500` server error.
- **Pagination:** `?page=1&page_size=20` → response `{ "items": [...], "page": 1, "page_size": 20, "total": 137 }`. Cursor pagination (`?cursor=`) for large time-series.
- **Filtering/sorting:** `?status=applied&sort=-created_at&q=google`.
- **Idempotency:** unsafe POSTs accept `Idempotency-Key` header.
- **Versioning:** URI-versioned (`/v1`); breaking changes → `/v2`.
- **Tenant isolation:** all resources implicitly scoped to the authenticated user; cross-user access → `403/404`.
- **Rate limiting:** per-user + per-IP token bucket; AI endpoints have stricter tiers (see doc 11). `429` returns `Retry-After`.

### Standard error envelope
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "role_title is required",
    "details": [ { "field": "role_title", "issue": "missing" } ],
    "request_id": "req_01HXYZ..."
  }
}
```

### Standard resource envelope (single)
```json
{ "data": { "id": "…", "…": "…" }, "request_id": "req_…" }
```

---

## 5.2 Authentication APIs

| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/auth/register` | Create account |
| POST | `/auth/verify-email` | Verify via token |
| POST | `/auth/login` | Password login → tokens |
| POST | `/auth/oauth/{provider}` | OAuth (google/github) code exchange |
| POST | `/auth/refresh` | Rotate refresh → new access |
| POST | `/auth/logout` | Revoke current refresh token |
| POST | `/auth/logout-all` | Revoke all sessions |
| POST | `/auth/password/forgot` | Send reset email |
| POST | `/auth/password/reset` | Reset with token |
| POST | `/auth/2fa/enable` · `/auth/2fa/verify` | TOTP setup/verify |
| GET  | `/auth/me` | Current user + roles |

**POST `/auth/register`**
- Request: `{ "email": "a@b.com", "password": "••••••••", "full_name": "Aarav" }`
- Validation: valid email (unique), password ≥ 10 chars w/ complexity, name 1–80 chars.
- Response `201`: `{ "data": { "id": "...", "email": "...", "status": "pending" } }` + verification email queued.
- Errors: `409 EMAIL_TAKEN`, `400 VALIDATION_ERROR`.

**POST `/auth/login`**
- Request: `{ "email": "...", "password": "...", "otp": "123456"? }`
- Response `200`: `{ "data": { "access_token": "...", "token_type": "bearer", "expires_in": 900, "user": {...} } }` (refresh set as httpOnly cookie).
- Errors: `401 INVALID_CREDENTIALS`, `403 EMAIL_NOT_VERIFIED`, `401 OTP_REQUIRED`, `429 TOO_MANY_ATTEMPTS`.

**POST `/auth/refresh`** — reads refresh cookie → `200` new access token; `401 INVALID_REFRESH` if revoked/expired (rotation invalidates old).

---

## 5.3 Users, Profile, Roadmap

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET/PATCH | `/me/profile` | Get/update profile |
| POST | `/me/avatar` | Upload avatar (presigned) |
| GET | `/target-roles` | List selectable roles |
| GET/POST | `/me/roadmaps` | List / create roadmap |
| GET/PATCH/DELETE | `/me/roadmaps/{id}` | Manage roadmap |
| POST | `/me/roadmaps/{id}/activate` | Set active |
| GET/POST | `/me/roadmaps/{id}/milestones` | List/add milestones |
| PATCH/DELETE | `/roadmap-milestones/{id}` | Update/remove |

**POST `/me/roadmaps`**
- Request: `{ "target_role_id": "...", "title": "Data Engineer Path", "target_date": "2026-04-30" }`
- Validation: role exists; `target_date` ≥ today.
- Response `201`: roadmap object with generated default milestones (from role template).
- Errors: `404 ROLE_NOT_FOUND`, `422 INVALID_DATE`.

---

## 5.4 Learning APIs

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/domains` | List learning domains (+topics tree via `?expand=topics`) |
| GET | `/domains/{id}/topics` | Topics of a domain |
| GET | `/topics/{id}` | Topic + sub-topics + resources |
| GET/PUT | `/me/domains` | Get/set tracked domains + priorities |
| GET | `/me/learning/progress` | Progress across topics (filter by domain/status) |
| PATCH | `/me/topics/{topicId}/progress` | Upsert progress/mastery |
| POST | `/me/topics/{topicId}/notes` | Save note |
| GET | `/me/revision/due` | Due revision items |
| POST | `/me/revision/{id}/complete` | Mark reviewed (reschedules) |
| GET/POST | `/me/resources` | List/attach resources |

**PATCH `/me/topics/{topicId}/progress`**
- Request: `{ "sub_topic_id": null, "status": "in_progress", "level": "practiced", "mastery_pct": 60, "confidence": 3 }`
- Validation: enums valid; `mastery_pct` 0–100; `confidence` 0–5; topic exists.
- Response `200`: updated progress; side-effects: recompute learning sub-score, (re)schedule revision, emit `topic.progress_updated`.
- Errors: `404 TOPIC_NOT_FOUND`, `422`.

---

## 5.5 Coding APIs

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET/POST | `/me/coding/problems` | List/create problems |
| GET/PATCH/DELETE | `/me/coding/problems/{id}` | Manage problem |
| GET | `/me/coding/heatmap` | Daily solved counts (calendar) |
| GET | `/me/coding/coverage` | Topic/difficulty coverage |
| GET | `/me/coding/revisit` | Problems flagged revisit |

**POST `/me/coding/problems`**
- Request: `{ "title": "Two Sum", "platform": "leetcode", "url": "...", "difficulty": "easy", "topic_id": "...", "status": "solved", "time_spent_min": 15 }`
- Validation: title required; difficulty enum; if status=solved → `solved_at` defaulted now.
- Response `201`: problem; emits `problem.solved` → streak/score recompute.

---

## 5.6 Projects APIs

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET/POST | `/me/projects` | List/create |
| GET/PATCH/DELETE | `/me/projects/{id}` | Manage |
| GET/POST | `/me/projects/{id}/milestones` | Milestones |
| GET/POST | `/me/projects/{id}/tasks` | Project tasks |
| POST | `/me/projects/{id}/link-repo` | Link GitHub repo |

**POST `/me/projects`** — Request: `{ "title": "ETL Pipeline", "tech_stack": ["python","airflow"], "status":"planning" }` → `201` project. Errors: `422`.

---

## 5.7 Sprint & Tasks APIs

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET/POST | `/me/sprints` | List/create sprints |
| GET/PATCH/DELETE | `/me/sprints/{id}` | Manage sprint |
| POST | `/me/sprints/{id}/activate` · `/complete` | Lifecycle |
| GET/POST | `/me/tasks` | List/create tasks (filters: status,type,sprint,project,due) |
| PATCH/DELETE | `/me/tasks/{id}` | Update (status move on Kanban)/remove |
| GET | `/me/tasks/today` | Daily aggregated tasks |
| POST | `/me/daily/plan` | Set today's plan (task ids + order) |
| GET/POST | `/me/weekly-reviews` | List/create weekly review |

**PATCH `/me/tasks/{id}`** — Request: `{ "status": "done" }` → `200`; sets `completed_at`, updates sprint velocity, emits `task.completed`.

---

## 5.8 Resume APIs

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET/POST | `/me/resumes` | List/create versions |
| GET/PATCH/DELETE | `/me/resumes/{id}` | Manage |
| PUT | `/me/resumes/{id}/sections` | Replace sections |
| POST | `/me/resumes/{id}/ats-scan` | Run ATS scoring vs. target role/JD |
| POST | `/me/resumes/{id}/export` | Generate PDF (async → file_key) |
| POST | `/me/resumes/{id}/set-primary` | Mark primary |

**POST `/me/resumes/{id}/ats-scan`**
- Request: `{ "target_role_id": "...", "job_description": "optional text" }`
- Response `200`: `{ "data": { "ats_score": 78.5, "matched": ["sql","etl"], "missing": ["airflow","spark"], "suggestions": [...] } }`
- Errors: `404`, `429 AI_RATE_LIMIT`.

---

## 5.9 GitHub APIs

| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/me/github/connect` | Start OAuth link |
| POST | `/me/github/sync` | Trigger repo/activity sync (async) |
| GET | `/me/github/repos` | List synced repos |
| GET | `/me/github/stats` | Languages, commits, contribution summary |
| DELETE | `/me/github/disconnect` | Unlink |

**POST `/me/github/sync`** → `202 Accepted` `{ "job_id": "..." }`; poll `/jobs/{id}` or receive notification on completion.

---

## 5.10 LinkedIn APIs

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET/PUT | `/me/linkedin` | Get/update tracked profile |
| GET/POST | `/me/linkedin/activities` | Networking log |
| GET | `/me/linkedin/completeness` | Completeness breakdown |

---

## 5.11 Company APIs (CRM)

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET/POST | `/me/companies` | List/create (search `?q=`) |
| GET/PATCH/DELETE | `/me/companies/{id}` | Manage |
| GET/POST | `/me/companies/{id}/contacts` | Contacts |
| PATCH/DELETE | `/company-contacts/{id}` | Manage contact |

---

## 5.12 Application APIs

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET/POST | `/me/applications` | List (funnel filters)/create |
| GET/PATCH/DELETE | `/me/applications/{id}` | Manage |
| POST | `/me/applications/{id}/status` | Transition status |
| GET | `/me/applications/funnel` | Funnel counts + conversion |
| GET | `/me/applications/upcoming-deadlines` | Deadline reminders feed |

**POST `/me/applications/{id}/status`**
- Request: `{ "status": "interview", "note": "onsite scheduled" }`
- Validation: legal transition (e.g., cannot go `rejected → offer`); emits `application.status_changed`.
- Response `200`: updated application. Errors: `409 ILLEGAL_TRANSITION`.

---

## 5.13 Interview APIs

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET/POST | `/me/applications/{id}/interviews` | List/add rounds |
| GET/PATCH/DELETE | `/me/interviews/{id}` | Manage |
| GET/POST | `/me/interviews/{id}/questions` | Question bank per interview |
| GET | `/me/interviews/upcoming` | Upcoming interviews |

---

## 5.14 Analytics APIs

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/me/analytics/overview` | Overall dashboard payload |
| GET | `/me/analytics/learning` | Learning dashboard |
| GET | `/me/analytics/coding` | Coding dashboard |
| GET | `/me/analytics/projects` | Project dashboard |
| GET | `/me/analytics/placement` | Placement/funnel dashboard |
| GET | `/me/analytics/company` | Company dashboard |
| GET | `/me/analytics/interview` | Interview dashboard |
| GET | `/me/analytics/career` | Career/roadmap dashboard |
| GET | `/me/career-readiness-index` | Current score + breakdown |
| GET | `/me/career-readiness-index/history?range=90d` | Trend series |

**GET `/me/career-readiness-index`** → `200`
```json
{ "data": {
  "score": 72.4,
  "breakdown": { "learning": 80, "coding": 65, "projects": 70, "resume": 75,
                 "github": 60, "linkedin": 55, "applications": 85, "interviews": 68 },
  "delta_7d": 3.1, "computed_at": "2026-07-11T20:00:00Z" } }
```

---

## 5.15 AI APIs

| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/me/ai/coach` | Ask career coach (chat, streaming) |
| POST | `/me/ai/resume-review` | Structured resume feedback |
| POST | `/me/ai/mock-interview/start` · `/turn` · `/finish` | Mock interview session |
| GET  | `/me/ai/recommendations` | Learning/revision/project/company recos |
| GET  | `/me/ai/weak-areas` | Weak-area detection |
| POST | `/me/ai/sprint-plan` | Auto-generate a sprint |
| GET  | `/me/ai/interview-prediction?application_id=` | Outcome probability |

**POST `/me/ai/coach`**
- Request: `{ "message": "What should I focus on this week?", "context": { "include_score": true } }`
- Response: SSE stream of tokens then final `{ "data": { "reply": "...", "citations": [...], "actions": [ {"type":"create_task", ...} ] } }`
- Errors: `429 AI_RATE_LIMIT`, `402 UPGRADE_REQUIRED` (free-tier cap), `503 AI_UNAVAILABLE` (graceful fallback message).

---

## 5.16 Notifications & Settings APIs

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/me/notifications` | List (`?unread=true`) |
| POST | `/me/notifications/{id}/read` · `/read-all` | Mark read |
| GET/PUT | `/me/settings/notifications` | Channel/type preferences |
| GET/PUT | `/me/settings/preferences` | Theme, locale, quiet hours |
| GET | `/me/goals` · POST · PATCH · DELETE | Goals CRUD |
| GET | `/me/achievements` | Earned badges |
| GET | `/me/export` | Full account data export (async) |
| DELETE | `/me/account` | Delete account (soft → purge job) |

---

## 5.17 Admin APIs (RBAC: admin)

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/admin/users` | List/search users |
| PATCH | `/admin/users/{id}/status` | Suspend/activate |
| GET/POST/PATCH | `/admin/domains`, `/admin/topics`, `/admin/target-roles` | Content management |
| GET/POST | `/admin/roadmap-templates` | Manage role roadmap templates |
| GET | `/admin/audit-logs` | Audit trail |
| GET/PUT | `/admin/feature-flags` | Toggle features |
| GET | `/admin/analytics/cohort` | Cohort/institutional analytics (future) |

All admin routes require role `admin`/`institution_admin`; unauthorized → `403 FORBIDDEN`. All admin mutations write `audit_logs`.

---

## 5.18 System APIs

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/health` | Liveness |
| GET | `/ready` | Readiness (db/redis checks) |
| GET | `/jobs/{id}` | Async job status |
| GET | `/api/docs` · `/api/openapi.json` | API docs / spec |

## 5.19 Validation & error catalog (common codes)

| Code | HTTP | Meaning |
|------|------|---------|
| `VALIDATION_ERROR` | 400/422 | Bad/missing fields |
| `UNAUTHENTICATED` | 401 | Missing/invalid token |
| `FORBIDDEN` | 403 | RBAC/ownership denied |
| `NOT_FOUND` | 404 | Resource missing or not owned |
| `CONFLICT` | 409 | Duplicate / illegal state transition |
| `RATE_LIMITED` | 429 | Too many requests (`Retry-After`) |
| `AI_RATE_LIMIT` | 429 | AI quota exceeded |
| `UPGRADE_REQUIRED` | 402 | Feature gated to Pro |
| `AI_UNAVAILABLE` | 503 | LLM/provider down (graceful) |
| `INTERNAL_ERROR` | 500 | Unexpected (with `request_id`) |
