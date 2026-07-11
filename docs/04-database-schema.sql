-- ============================================================================
-- CareerOS — AI-Powered Career Intelligence Platform — PostgreSQL 16 Schema
-- Full DDL: extensions, enums, tables, constraints, indexes, triggers.
-- Convention: UUID PKs, TIMESTAMPTZ (UTC), tenant-scoped by user_id,
--             soft-delete via deleted_at where user-recoverable.
-- ============================================================================

-- ---------- Extensions ----------
CREATE EXTENSION IF NOT EXISTS "pgcrypto";     -- gen_random_uuid()
CREATE EXTENSION IF NOT EXISTS "pg_trgm";       -- trigram search
CREATE EXTENSION IF NOT EXISTS "citext";        -- case-insensitive email
CREATE EXTENSION IF NOT EXISTS "vector";        -- pgvector (RAG embeddings)

-- ---------- Reusable updated_at trigger ----------
CREATE OR REPLACE FUNCTION set_updated_at() RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END; $$ LANGUAGE plpgsql;

-- ---------- Enum types ----------
CREATE TYPE user_status         AS ENUM ('pending','active','suspended','deleted');
CREATE TYPE proficiency_level   AS ENUM ('not_started','learning','practiced','proficient','mastered');
CREATE TYPE progress_status     AS ENUM ('not_started','in_progress','completed','needs_revision');
CREATE TYPE difficulty_level    AS ENUM ('easy','medium','hard');
CREATE TYPE problem_status      AS ENUM ('todo','attempted','solved','revisit');
CREATE TYPE task_status         AS ENUM ('backlog','todo','in_progress','blocked','done');
CREATE TYPE task_priority       AS ENUM ('low','medium','high','critical');
CREATE TYPE task_type           AS ENUM ('learning','coding','project','application','interview','general');
CREATE TYPE project_status      AS ENUM ('idea','planning','in_progress','completed','archived');
CREATE TYPE sprint_status       AS ENUM ('planned','active','completed','cancelled');
CREATE TYPE application_status  AS ENUM ('saved','applied','oa','interview','offer','accepted','rejected','withdrawn');
CREATE TYPE interview_type      AS ENUM ('screening','technical','coding','system_design','behavioral','hr','managerial','other');
CREATE TYPE interview_mode      AS ENUM ('online','onsite','phone','take_home');
CREATE TYPE interview_status    AS ENUM ('scheduled','completed','cancelled','no_show');
CREATE TYPE interview_outcome   AS ENUM ('pending','passed','failed','ghosted');
CREATE TYPE resource_type       AS ENUM ('video','article','course','book','doc','other');
CREATE TYPE resume_section_type AS ENUM ('summary','experience','education','projects','skills','certifications','achievements','custom');
CREATE TYPE goal_status         AS ENUM ('active','achieved','missed','abandoned');
CREATE TYPE notification_type   AS ENUM ('deadline','revision','sprint','achievement','ai_nudge','system','interview');
CREATE TYPE notification_channel AS ENUM ('in_app','email','push');
CREATE TYPE notification_status AS ENUM ('pending','sent','failed','read');
CREATE TYPE ai_feature          AS ENUM ('coach','resume_review','mock_interview','recommendation','weak_area','sprint_plan','company_reco','interview_prediction');

-- ============================================================================
-- IDENTITY & ACCESS
-- ============================================================================
CREATE TABLE users (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email          CITEXT UNIQUE NOT NULL,
  password_hash  TEXT,                       -- null if OAuth-only
  status         user_status NOT NULL DEFAULT 'pending',
  email_verified BOOLEAN NOT NULL DEFAULT false,
  is_2fa_enabled BOOLEAN NOT NULL DEFAULT false,
  totp_secret    TEXT,
  last_login_at  TIMESTAMPTZ,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at     TIMESTAMPTZ
);
CREATE INDEX idx_users_status ON users(status);

CREATE TABLE roles (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code        TEXT UNIQUE NOT NULL,           -- student, admin, coach, institution_admin
  name        TEXT NOT NULL,
  description TEXT
);

CREATE TABLE user_roles (
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  role_id UUID NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
  PRIMARY KEY (user_id, role_id)
);

CREATE TABLE profiles (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  full_name     TEXT,
  avatar_key    TEXT,
  headline      TEXT,
  college       TEXT,
  branch        TEXT,
  graduation_year SMALLINT,
  target_date   DATE,                          -- placement target deadline
  phone         TEXT,
  location      TEXT,
  timezone      TEXT DEFAULT 'UTC',
  bio           TEXT,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE refresh_tokens (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  token_hash  TEXT NOT NULL,
  device_info TEXT,
  ip          INET,
  expires_at  TIMESTAMPTZ NOT NULL,
  revoked_at  TIMESTAMPTZ,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_refresh_user ON refresh_tokens(user_id);

-- ============================================================================
-- CAREER TARGETING & ROADMAP
-- ============================================================================
CREATE TABLE target_roles (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code        TEXT UNIQUE NOT NULL,            -- data_engineer, data_analyst, ...
  name        TEXT NOT NULL,
  category    TEXT NOT NULL DEFAULT 'primary', -- primary | secondary
  skill_weights JSONB NOT NULL DEFAULT '{}',   -- {"sql":0.25,"python":0.2,...}
  description TEXT
);

CREATE TABLE career_roadmaps (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  target_role_id UUID NOT NULL REFERENCES target_roles(id) ON DELETE RESTRICT,
  title         TEXT NOT NULL,
  is_active     BOOLEAN NOT NULL DEFAULT true,
  target_date   DATE,
  progress_pct  NUMERIC(5,2) NOT NULL DEFAULT 0,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_roadmap_user ON career_roadmaps(user_id, is_active);

CREATE TABLE roadmap_milestones (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  roadmap_id   UUID NOT NULL REFERENCES career_roadmaps(id) ON DELETE CASCADE,
  title        TEXT NOT NULL,
  description  TEXT,
  order_index  INTEGER NOT NULL DEFAULT 0,
  status       progress_status NOT NULL DEFAULT 'not_started',
  due_date     DATE,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_milestone_roadmap ON roadmap_milestones(roadmap_id, order_index);

-- ============================================================================
-- LEARNING (LMS)
-- ============================================================================
CREATE TABLE learning_domains (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code        TEXT UNIQUE NOT NULL,            -- python, sql, dsa, excel, power_bi ...
  name        TEXT NOT NULL,
  description TEXT,
  icon        TEXT,
  order_index INTEGER NOT NULL DEFAULT 0,
  is_active   BOOLEAN NOT NULL DEFAULT true
);

CREATE TABLE topics (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  domain_id   UUID NOT NULL REFERENCES learning_domains(id) ON DELETE CASCADE,
  name        TEXT NOT NULL,
  description TEXT,
  order_index INTEGER NOT NULL DEFAULT 0,
  difficulty  difficulty_level DEFAULT 'medium'
);
CREATE INDEX idx_topics_domain ON topics(domain_id, order_index);

CREATE TABLE sub_topics (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  topic_id    UUID NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
  name        TEXT NOT NULL,
  order_index INTEGER NOT NULL DEFAULT 0
);
CREATE INDEX idx_subtopics_topic ON sub_topics(topic_id, order_index);

CREATE TABLE user_domains (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  domain_id  UUID NOT NULL REFERENCES learning_domains(id) ON DELETE CASCADE,
  priority   task_priority NOT NULL DEFAULT 'medium',
  weight     NUMERIC(4,2) NOT NULL DEFAULT 1.0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (user_id, domain_id)
);

CREATE TABLE topic_progress (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  topic_id      UUID NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
  sub_topic_id  UUID REFERENCES sub_topics(id) ON DELETE CASCADE,
  status        progress_status NOT NULL DEFAULT 'not_started',
  level         proficiency_level NOT NULL DEFAULT 'not_started',
  mastery_pct   NUMERIC(5,2) NOT NULL DEFAULT 0,
  confidence    SMALLINT CHECK (confidence BETWEEN 0 AND 5),
  notes         TEXT,
  last_reviewed TIMESTAMPTZ,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (user_id, topic_id, sub_topic_id)
);
CREATE INDEX idx_tp_user_topic  ON topic_progress(user_id, topic_id);
CREATE INDEX idx_tp_user_status ON topic_progress(user_id, status);
CREATE INDEX idx_tp_reviewed    ON topic_progress(user_id, last_reviewed);

CREATE TABLE revision_schedule (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  topic_progress_id UUID NOT NULL REFERENCES topic_progress(id) ON DELETE CASCADE,
  due_date         DATE NOT NULL,
  interval_days    INTEGER NOT NULL DEFAULT 1,
  ease_factor      NUMERIC(4,2) NOT NULL DEFAULT 2.5,
  repetitions      INTEGER NOT NULL DEFAULT 0,
  completed_at     TIMESTAMPTZ,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_revision_due ON revision_schedule(user_id, due_date);

CREATE TABLE resources (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID REFERENCES users(id) ON DELETE CASCADE,   -- null = global/curated
  title       TEXT NOT NULL,
  url         TEXT,
  type        resource_type NOT NULL DEFAULT 'article',
  provider    TEXT,
  is_curated  BOOLEAN NOT NULL DEFAULT false,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE topic_resources (
  topic_id    UUID NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
  resource_id UUID NOT NULL REFERENCES resources(id) ON DELETE CASCADE,
  PRIMARY KEY (topic_id, resource_id)
);

-- ============================================================================
-- CODING TRACKER
-- ============================================================================
CREATE TABLE coding_problems (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  topic_id     UUID REFERENCES topics(id) ON DELETE SET NULL,
  title        TEXT NOT NULL,
  platform     TEXT,                            -- leetcode, hackerrank, ...
  url          TEXT,
  difficulty   difficulty_level DEFAULT 'medium',
  status       problem_status NOT NULL DEFAULT 'todo',
  time_spent_min INTEGER,
  attempts     INTEGER NOT NULL DEFAULT 0,
  revisit      BOOLEAN NOT NULL DEFAULT false,
  solved_at    TIMESTAMPTZ,
  notes        TEXT,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_cp_user_solved ON coding_problems(user_id, solved_at);
CREATE INDEX idx_cp_user_topic  ON coding_problems(user_id, topic_id);
CREATE INDEX idx_cp_user_status ON coding_problems(user_id, status);

-- ============================================================================
-- PROJECTS
-- ============================================================================
CREATE TABLE github_repositories (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  gh_id         BIGINT,
  name          TEXT NOT NULL,
  full_name     TEXT,
  url           TEXT,
  description   TEXT,
  languages     JSONB NOT NULL DEFAULT '{}',
  stars         INTEGER NOT NULL DEFAULT 0,
  forks         INTEGER NOT NULL DEFAULT 0,
  commit_count  INTEGER NOT NULL DEFAULT 0,
  is_fork       BOOLEAN NOT NULL DEFAULT false,
  last_pushed_at TIMESTAMPTZ,
  synced_at     TIMESTAMPTZ,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (user_id, gh_id)
);
CREATE INDEX idx_ghrepo_user ON github_repositories(user_id);

CREATE TABLE projects (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  github_repo_id UUID REFERENCES github_repositories(id) ON DELETE SET NULL,
  title         TEXT NOT NULL,
  description   TEXT,
  tech_stack    TEXT[],
  status        project_status NOT NULL DEFAULT 'idea',
  repo_url      TEXT,
  live_url      TEXT,
  role_relevance NUMERIC(4,2),                  -- how relevant to target role
  started_at    DATE,
  completed_at  DATE,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at    TIMESTAMPTZ
);
CREATE INDEX idx_projects_user ON projects(user_id, status);

CREATE TABLE milestones (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id  UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  title       TEXT NOT NULL,
  status      progress_status NOT NULL DEFAULT 'not_started',
  due_date    DATE,
  order_index INTEGER NOT NULL DEFAULT 0,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_milestones_project ON milestones(project_id, order_index);

-- ============================================================================
-- SPRINT & TASKS  (tasks are shared by projects, sprints, daily view)
-- ============================================================================
CREATE TABLE sprints (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name        TEXT NOT NULL,
  goal        TEXT,
  status      sprint_status NOT NULL DEFAULT 'planned',
  start_date  DATE NOT NULL,
  end_date    DATE NOT NULL,
  velocity    INTEGER,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  CHECK (end_date >= start_date)
);
CREATE INDEX idx_sprints_user ON sprints(user_id, status);

CREATE TABLE tasks (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  sprint_id    UUID REFERENCES sprints(id) ON DELETE SET NULL,
  project_id   UUID REFERENCES projects(id) ON DELETE CASCADE,
  milestone_id UUID REFERENCES milestones(id) ON DELETE SET NULL,
  domain_id    UUID REFERENCES learning_domains(id) ON DELETE SET NULL,
  application_id UUID,                          -- FK added after applications table
  title        TEXT NOT NULL,
  description  TEXT,
  type         task_type NOT NULL DEFAULT 'general',
  status       task_status NOT NULL DEFAULT 'todo',
  priority     task_priority NOT NULL DEFAULT 'medium',
  estimate_pts SMALLINT,
  due_date     DATE,
  completed_at TIMESTAMPTZ,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_tasks_user_status ON tasks(user_id, status);
CREATE INDEX idx_tasks_sprint      ON tasks(sprint_id);
CREATE INDEX idx_tasks_due         ON tasks(user_id, due_date);
CREATE INDEX idx_tasks_project     ON tasks(project_id);

-- Daily plan entries (materialized "today"); optional — a view is also possible.
CREATE TABLE daily_tasks (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  task_id     UUID REFERENCES tasks(id) ON DELETE CASCADE,
  plan_date   DATE NOT NULL,
  is_done     BOOLEAN NOT NULL DEFAULT false,
  order_index INTEGER NOT NULL DEFAULT 0,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (user_id, task_id, plan_date)
);
CREATE INDEX idx_daily_user_date ON daily_tasks(user_id, plan_date);

CREATE TABLE weekly_reviews (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  week_start   DATE NOT NULL,
  week_end     DATE NOT NULL,
  wins         TEXT,
  blockers     TEXT,
  reflection   TEXT,
  metrics      JSONB NOT NULL DEFAULT '{}',     -- snapshot: problems solved, topics, apps
  next_plan    JSONB NOT NULL DEFAULT '{}',
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (user_id, week_start)
);

-- ============================================================================
-- RESUME (ATS)
-- ============================================================================
CREATE TABLE resume_versions (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id        UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  target_role_id UUID REFERENCES target_roles(id) ON DELETE SET NULL,
  name           TEXT NOT NULL,
  is_primary     BOOLEAN NOT NULL DEFAULT false,
  ats_score      NUMERIC(5,2),
  keyword_coverage JSONB NOT NULL DEFAULT '{}', -- {"matched":[],"missing":[]}
  file_key       TEXT,                          -- object storage key for PDF
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at     TIMESTAMPTZ
);
CREATE INDEX idx_resume_user ON resume_versions(user_id);

CREATE TABLE resume_sections (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  resume_id   UUID NOT NULL REFERENCES resume_versions(id) ON DELETE CASCADE,
  type        resume_section_type NOT NULL,
  title       TEXT,
  body        JSONB NOT NULL DEFAULT '{}',      -- structured content
  order_index INTEGER NOT NULL DEFAULT 0,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_resume_sections ON resume_sections(resume_id, order_index);

-- ============================================================================
-- LINKEDIN & NETWORKING
-- ============================================================================
CREATE TABLE linkedin_profiles (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id        UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  profile_url    TEXT,
  headline       TEXT,
  completeness_pct NUMERIC(5,2) NOT NULL DEFAULT 0,
  connections    INTEGER NOT NULL DEFAULT 0,
  followers      INTEGER NOT NULL DEFAULT 0,
  last_synced_at TIMESTAMPTZ,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE networking_activities (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  activity_type TEXT NOT NULL,                  -- post, connection, message, comment
  target       TEXT,
  notes        TEXT,
  occurred_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_networking_user ON networking_activities(user_id, occurred_at);

-- ============================================================================
-- COMPANY CRM, APPLICATIONS, INTERVIEWS
-- ============================================================================
CREATE TABLE companies (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name        TEXT NOT NULL,
  industry    TEXT,
  location    TEXT,
  size        TEXT,
  website     TEXT,
  ctc_band    TEXT,
  priority    task_priority NOT NULL DEFAULT 'medium',
  source      TEXT,                              -- referral, portal, campus
  notes       TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_companies_user ON companies(user_id, priority);
CREATE INDEX idx_companies_name_trgm ON companies USING gin (name gin_trgm_ops);

CREATE TABLE company_contacts (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id  UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name        TEXT NOT NULL,
  role        TEXT,
  email       TEXT,
  linkedin_url TEXT,
  is_referrer BOOLEAN NOT NULL DEFAULT false,
  notes       TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_contacts_company ON company_contacts(company_id);

CREATE TABLE applications (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id           UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  company_id        UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  resume_version_id UUID REFERENCES resume_versions(id) ON DELETE SET NULL,
  role_title        TEXT NOT NULL,
  status            application_status NOT NULL DEFAULT 'saved',
  source            TEXT,
  job_url           TEXT,
  location          TEXT,
  ctc               NUMERIC(12,2),
  applied_at        TIMESTAMPTZ,
  deadline          TIMESTAMPTZ,
  last_activity_at  TIMESTAMPTZ,
  notes             TEXT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_apps_user_status ON applications(user_id, status);
CREATE INDEX idx_apps_deadline    ON applications(user_id, deadline);
CREATE INDEX idx_apps_company      ON applications(company_id);

-- deferred FK from tasks -> applications
ALTER TABLE tasks
  ADD CONSTRAINT fk_tasks_application
  FOREIGN KEY (application_id) REFERENCES applications(id) ON DELETE SET NULL;

CREATE TABLE interviews (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id        UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  application_id UUID NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
  round_no       SMALLINT NOT NULL DEFAULT 1,
  type           interview_type NOT NULL DEFAULT 'technical',
  mode           interview_mode NOT NULL DEFAULT 'online',
  status         interview_status NOT NULL DEFAULT 'scheduled',
  outcome        interview_outcome NOT NULL DEFAULT 'pending',
  scheduled_at   TIMESTAMPTZ,
  duration_min   INTEGER,
  interviewer    TEXT,
  self_rating    SMALLINT CHECK (self_rating BETWEEN 0 AND 5),
  feedback       TEXT,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_interviews_app  ON interviews(application_id);
CREATE INDEX idx_interviews_user ON interviews(user_id, scheduled_at);

CREATE TABLE interview_questions (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  interview_id UUID NOT NULL REFERENCES interviews(id) ON DELETE CASCADE,
  user_id      UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  question     TEXT NOT NULL,
  category     TEXT,
  difficulty   difficulty_level,
  self_rating  SMALLINT CHECK (self_rating BETWEEN 0 AND 5),
  answer_notes TEXT,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_iq_interview ON interview_questions(interview_id);

-- ============================================================================
-- ENGAGEMENT: GOALS & ACHIEVEMENTS
-- ============================================================================
CREATE TABLE goals (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title         TEXT NOT NULL,
  metric        TEXT,                            -- e.g. problems_solved
  target_value  NUMERIC,
  current_value NUMERIC NOT NULL DEFAULT 0,
  status        goal_status NOT NULL DEFAULT 'active',
  due_date      DATE,
  linked_type   TEXT,
  linked_id     UUID,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_goals_user ON goals(user_id, status);

CREATE TABLE achievements (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  code        TEXT NOT NULL,                     -- streak_7, first_offer ...
  title       TEXT NOT NULL,
  description TEXT,
  icon        TEXT,
  meta        JSONB NOT NULL DEFAULT '{}',
  earned_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (user_id, code)
);

-- ============================================================================
-- CROSS-CUTTING: NOTIFICATIONS, ANALYTICS, SCORE, AI, AUDIT
-- ============================================================================
CREATE TABLE notifications (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type        notification_type NOT NULL,
  channel     notification_channel NOT NULL DEFAULT 'in_app',
  status      notification_status NOT NULL DEFAULT 'pending',
  title       TEXT NOT NULL,
  body        TEXT,
  entity_type TEXT,
  entity_id   UUID,
  scheduled_for TIMESTAMPTZ,
  sent_at     TIMESTAMPTZ,
  read_at     TIMESTAMPTZ,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_notif_user_read ON notifications(user_id, read_at);
CREATE INDEX idx_notif_user_created ON notifications(user_id, created_at);

CREATE TABLE analytics_snapshots (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  period       TEXT NOT NULL,                    -- daily | weekly | monthly
  period_start DATE NOT NULL,
  metrics      JSONB NOT NULL DEFAULT '{}',      -- denormalized KPI blob
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (user_id, period, period_start)
);
CREATE INDEX idx_snap_user ON analytics_snapshots(user_id, period, period_start);

-- Career Readiness Index (CRI) time series (formerly employability_scores).
CREATE TABLE readiness_scores (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  score       NUMERIC(5,2) NOT NULL,             -- 0-100 (CRI)
  breakdown   JSONB NOT NULL DEFAULT '{}',       -- sub-scores by pillar
  computed_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_readiness_user ON readiness_scores(user_id, computed_at);

CREATE TABLE ai_interactions (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  feature      ai_feature NOT NULL,
  prompt_ref   TEXT,
  input_tokens INTEGER,
  output_tokens INTEGER,
  cost_usd     NUMERIC(10,5),
  rating       SMALLINT CHECK (rating BETWEEN 1 AND 5),
  meta         JSONB NOT NULL DEFAULT '{}',
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_ai_user ON ai_interactions(user_id, created_at);

CREATE TABLE embeddings (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  owner_type  TEXT NOT NULL,                     -- resume, topic_note, project ...
  owner_id    UUID NOT NULL,
  chunk       TEXT NOT NULL,
  embedding   vector(1536) NOT NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_embeddings_ann ON embeddings USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100);

CREATE TABLE audit_logs (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_id    UUID REFERENCES users(id) ON DELETE SET NULL,
  action      TEXT NOT NULL,
  entity_type TEXT,
  entity_id   UUID,
  ip          INET,
  meta        JSONB NOT NULL DEFAULT '{}',
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_audit_actor ON audit_logs(actor_id, created_at);

-- ============================================================================
-- updated_at triggers (attach to mutable tables)
-- ============================================================================
DO $$
DECLARE t TEXT;
BEGIN
  FOR t IN SELECT unnest(ARRAY[
    'users','profiles','career_roadmaps','roadmap_milestones','topic_progress',
    'coding_problems','projects','milestones','sprints','tasks','weekly_reviews',
    'resume_versions','resume_sections','linkedin_profiles','companies',
    'applications','interviews','goals'
  ]) LOOP
    EXECUTE format(
      'CREATE TRIGGER trg_%1$s_updated BEFORE UPDATE ON %1$s
       FOR EACH ROW EXECUTE FUNCTION set_updated_at();', t);
  END LOOP;
END $$;

-- ============================================================================
-- Read-optimized view: application funnel counts per user
-- ============================================================================
CREATE VIEW v_application_funnel AS
SELECT user_id,
       count(*) FILTER (WHERE status='saved')     AS saved,
       count(*) FILTER (WHERE status='applied')   AS applied,
       count(*) FILTER (WHERE status='oa')        AS oa,
       count(*) FILTER (WHERE status='interview') AS interview,
       count(*) FILTER (WHERE status='offer')     AS offer,
       count(*) FILTER (WHERE status='accepted')  AS accepted,
       count(*) FILTER (WHERE status='rejected')  AS rejected
FROM applications
GROUP BY user_id;

-- ============================================================================
-- NOTE on partitioning (future): convert high-volume tables to declarative
-- range partitions by month, e.g.:
--   CREATE TABLE notifications (...) PARTITION BY RANGE (created_at);
-- ============================================================================
