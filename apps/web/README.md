# CareerOS Web (`apps/web`)

Next.js (App Router) + TypeScript frontend for CareerOS.

**Status (S1-1):** scaffold only — TypeScript strict, ESLint (shared preset), and a
minimal buildable page. The real application shell (navigation, design tokens,
light/dark theming, typed API client wiring) is built in Stories **S1-6** and **S1-7**.

## Commands

```bash
npm run dev        # local dev server
npm run build      # production build
npm run lint       # ESLint
npm run typecheck  # tsc --noEmit
```

Run from the repo root with `npm run <task>` to execute across all workspaces via Turborepo.
