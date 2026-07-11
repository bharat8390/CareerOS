# ADR-0004: Frontend stack

- **Status:** Accepted
- **Date:** 2026-07-11
- **Author:** Frontend Lead
- **Deciders:** CTO, Lead Engineer
- **Tags:** frontend

## Context
CareerOS needs a data-dense, chart-heavy, accessible (WCAG 2.1 AA) app with dark/light theming and a public Portfolio Mode, built by one engineer. UI spec in [`../06-ui-ux-design.md`](../06-ui-ux-design.md).

## Problem
What frontend framework and supporting libraries should CareerOS use?

## Decision
We will use **Next.js (App Router) + React + TypeScript (strict)**, **TailwindCSS + shadcn/ui + Radix** for the design system, **TanStack Query** for server state, **Zustand** for light UI state, and **Recharts (D3 where custom)** for charts. The client consumes the API only through a **typed client generated from OpenAPI**. Auth tokens live in HttpOnly cookies.

## Alternatives Considered
- **Plain React SPA (Vite)** — fine, but loses SSR/routing/SEO needed for public Portfolio Mode.
- **Angular/Vue** — capable, but smaller shadcn/Radix ecosystem fit and less alignment with the team's TS/React skills.
- **Redux for all state** — heavier boilerplate than TanStack Query + Zustand for this app's needs.
- **Next.js + TanStack Query + Zustand (chosen)** — SSR for portfolio/SEO, great DX, strong a11y primitives.

## Trade-offs
Gain: SSR/SEO for public profiles, typed end-to-end contract, accessible primitives, fast iteration. Give up: Next.js framework complexity vs. a plain SPA (accepted for SSR/portfolio value).

## Consequences
- **Positive:** SEO-ready Portfolio Mode; generated types kill FE/BE drift; a11y baked in via Radix.
- **Negative:** server/client component discipline required; must keep generated types in sync in CI.
- **Follow-ups:** `packages/contracts` type-gen step; design tokens in `packages/ui-tokens`; axe a11y checks in CI.

## References
docs 06, 02 (presentation layer), 16 (standards).
