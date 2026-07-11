# 07 — User Journeys & Flows

Flow diagrams (Mermaid) for the primary end-to-end journey plus per-module flows.

## 7.1 Master daily journey

```mermaid
flowchart TD
  L[Login] --> D[Dashboard]
  D --> T[Today's Tasks]
  T --> LE[Learning]
  T --> CO[Coding]
  T --> PR[Projects]
  LE --> SP[Sprint update]
  CO --> SP
  PR --> SP
  SP --> WR[Weekly Review]
  WR --> AN[Analytics / Score update]
  AN --> D
```

## 7.2 Onboarding & first-run

```mermaid
flowchart TD
  R[Register] --> V{Email verified?}
  V -- no --> VE[Verify email link] --> V
  V -- yes --> WZ[Onboarding wizard]
  WZ --> Q1[Pick target role]
  Q1 --> Q2[Set graduation/target date]
  Q2 --> Q3[Select domains to focus]
  Q3 --> Q4[Optional: connect GitHub]
  Q4 --> GEN[Generate roadmap + starter sprint]
  GEN --> BASE[Compute baseline Career Readiness Index]
  BASE --> D[Dashboard ready]
```

## 7.3 Authentication flow

```mermaid
flowchart TD
  S[Start] --> C{Has account?}
  C -- no --> REG[Register] --> VER[Verify email] --> LOG
  C -- yes --> LOG[Login]
  LOG --> M{2FA enabled?}
  M -- yes --> OTP[Enter TOTP] --> ISS
  M -- no --> ISS[Issue access + refresh]
  ISS --> APP[Enter app]
  LOG -- forgot --> FP[Forgot password] --> RST[Reset link] --> LOG
```

## 7.4 Learning module flow

```mermaid
flowchart TD
  A[Open Learning] --> B[Pick domain]
  B --> C[Open topic]
  C --> D[Study + attach resources/notes]
  D --> E[Update progress/mastery]
  E --> F{Mastery high?}
  F -- yes --> G[Schedule spaced revision]
  F -- no --> H[Add task to sprint]
  G --> I[Recompute learning sub-score]
  H --> I
  I --> J[Revision reminders fire on due date]
```

## 7.5 Coding tracker flow

```mermaid
flowchart TD
  A[Open Coding] --> B[Log problem]
  B --> C{Solved?}
  C -- attempted --> D[Mark attempted + notes]
  C -- solved --> E[Mark solved + time]
  D --> F[Flag revisit]
  E --> G[Update streak + heatmap]
  F --> H[Revisit queue]
  G --> I[Recompute coding sub-score]
  H --> A
```

## 7.6 Projects flow

```mermaid
flowchart TD
  A[Create project] --> B[Define milestones]
  B --> C[Add tasks -> Kanban]
  C --> D[Work tasks / move columns]
  D --> E{Milestone done?}
  E -- yes --> F[Link GitHub repo + resume bullet]
  E -- no --> D
  F --> G[Project completed]
  G --> H[Boost project + github sub-scores]
```

## 7.7 Resume + ATS flow

```mermaid
flowchart TD
  A[Create resume version] --> B[Fill sections]
  B --> C[Pick target role / paste JD]
  C --> D[Run ATS scan]
  D --> E[View score + missing keywords]
  E --> F{Score ok?}
  F -- no --> G[Apply AI suggestions] --> D
  F -- yes --> H[Export PDF]
  H --> I[Attach version to applications]
```

## 7.8 Company CRM → Application → Interview → Offer flow

```mermaid
flowchart TD
  A[Save company] --> B[Add contacts]
  B --> C[Create application: Saved]
  C --> D[Apply -> set deadline + resume version]
  D --> E[Status: Applied]
  E --> F[OA received -> Status: OA]
  F --> G[Schedule interview rounds]
  G --> H[Log questions + feedback per round]
  H --> I{Outcome}
  I -- pass --> J[Status: Offer]
  I -- fail --> K[Status: Rejected -> capture learnings]
  J --> L[Accept -> Status: Accepted 🎉]
  K --> M[AI weak-area update + revision plan]
```

## 7.9 Sprint planning & daily execution flow

```mermaid
flowchart TD
  A[Start sprint] --> B[Pull tasks from backlog/roadmap]
  B --> C[Optional: AI auto-plan sprint]
  C --> D[Daily view: today's tasks]
  D --> E[Complete tasks]
  E --> F[Burndown updates]
  F --> G{Sprint end?}
  G -- no --> D
  G -- yes --> H[Weekly review]
  H --> I[Carry over + plan next sprint]
```

## 7.10 Weekly review flow

```mermaid
flowchart TD
  A[Open Weekly Review] --> B[Auto-populate metrics snapshot]
  B --> C[Write wins / blockers / reflection]
  C --> D[AI summarizes + suggests next focus]
  D --> E[Generate next-sprint plan]
  E --> F[Save review + snapshot]
```

## 7.11 AI Career Coach flow

```mermaid
flowchart TD
  A[Open Coach] --> B[Ask / pick suggested prompt]
  B --> C[Gateway assembles context: score, gaps, funnel]
  C --> D[LLM responds with guidance + action cards]
  D --> E{Accept action?}
  E -- yes --> F[Create tasks / sprint / revision]
  E -- no --> B
  F --> G[Rate response -> improves prompts]
```

## 7.12 Notification lifecycle

```mermaid
flowchart TD
  A[Trigger: deadline/revision/sprint/achievement/AI] --> B[Check user preferences + quiet hours]
  B --> C{Allowed?}
  C -- no --> Z[Suppress]
  C -- yes --> D[Create notification -> in-app]
  D --> E{Channel email/push?}
  E -- yes --> F[Enqueue delivery job]
  F --> G[Send via provider -> mark sent]
  D --> H[User reads -> mark read]
```

## 7.13 Career Readiness Index recompute (event-driven)

```mermaid
flowchart TD
  A[Domain event: progress/solve/ship/apply/interview] --> B[Enqueue score recompute]
  B --> C[Gather pillar sub-scores]
  C --> D[Apply role-weighted formula]
  D --> E[Persist readiness_scores row]
  E --> F[Update dashboard + trend]
  F --> G{Crossed threshold?}
  G -- yes --> H[Unlock achievement + notify]
```
