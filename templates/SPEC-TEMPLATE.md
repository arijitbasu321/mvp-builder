# Project Specification

## Project Overview

<!-- 2-3 paragraphs: What is this product? Why does it exist? Who is it for? -->

## Agent Team Structure

| Role | Responsibilities | When Invoked |
|------|-----------------|--------------|
| Project Manager | Orchestrates development, delegates tasks, manages state, reviews work, escalates to human | Always active during Phase II |
| Architect | Designs technical system based on UI/UX design (upfront + per-milestone), resolves merge conflicts, resolves technical conflicts, tests eval conditions | Upfront design (after UI/UX), start of each milestone (after UI/UX), on-demand for conflicts |
| Developer | Writes application code, implements features, writes unit/integration tests. Managed with atomic tasks and frequent recycling to prevent context bloat | During wave execution |
| UI Designer | Creates overall UI/UX design (upfront), milestone-specific UI/UX details, reviews UI/UX quality | Upfront design (first), start of each milestone (first), wave and milestone reviews |
| QA Tester | Runs unit tests, E2E tests (Playwright), tests prompts against Golden Dataset with LLM-as-a-Judge | After each wave (before reviews), milestone-level reviews |
| Proofreader | Checks all user-facing text for spelling, grammar, tone consistency | Wave-level and milestone-level reviews |
| DevOps | Deploys to non-prod and prod, manages infrastructure, environment config | After dev waves and at milestone completion |

> Adjust this table during Phase I if the product demands different roles (e.g., add Security reviewer, remove DevOps if static hosting).

## Tech Stack

| Layer | Choice | Justification |
|-------|--------|---------------|
| Frontend | <!-- e.g., Next.js 15 --> | <!-- 1-line reason --> |
| Backend | <!-- e.g., Next.js API routes --> | <!-- 1-line reason --> |
| Database | <!-- e.g., PostgreSQL via Supabase --> | <!-- 1-line reason --> |
| Auth | <!-- e.g., Supabase Auth --> | <!-- 1-line reason --> |
| AI Provider | <!-- e.g., Anthropic Claude --> | <!-- 1-line reason --> |
| Hosting | <!-- e.g., Vercel --> | <!-- 1-line reason --> |
| CSS/UI | <!-- e.g., Tailwind + shadcn/ui --> | <!-- 1-line reason --> |
| Testing | <!-- e.g., Vitest + Playwright --> | <!-- 1-line reason --> |

## Deployment Strategy

### Non-Production

<!-- How to run locally, staging environment, environment variables needed -->

<!-- FILL-THIS-IN: Local dev command (e.g., `npm run dev`) -->
<!-- FILL-THIS-IN: Staging URL if applicable -->
<!-- FILL-THIS-IN: Required environment variables and how to obtain them -->

### Production

<!-- FILL-THIS-IN: Hosting platform and deployment method -->
<!-- FILL-THIS-IN: Production domain -->
<!-- FILL-THIS-IN: SSL configuration -->
<!-- FILL-THIS-IN: Database hosting and connection -->

## Golden Rules

These rules are mechanically enforced by hooks. They are not suggestions.

1. **Agent Teams with worktrees** — All teammates are spawned via `TeamCreate`/`Task` with `team_name`. No bare sub-agents. Each teammate works in an isolated git worktree.
2. **Unit tests with coverage** — All code must have unit tests. Coverage must meet the project threshold (default 80%). All tests must pass.
3. **Playwright E2E tests** — UI features must have Playwright tests validating user flows.
4. **LEARNINGS.md is maintained** — Every discovery, gotcha, or pattern that affects future work is recorded. Pruned at milestone boundaries.
5. **DECISIONS.md is append-only** — Every settled decision is logged. Never edited or deleted. One concise line per entry.
6. **ISSUES.md is PM-only** — Only the Project Manager writes to ISSUES.md. Teammates report issues via SendMessage.
7. **STATE.md stays small** — STATE.md must not exceed 50 lines. Contains only: current milestone, current wave, what's done, what's blocked.

## Review Structure

### Wave-Level Reviews (after each development wave)

| Review Type | Reviewer | What They Check |
|-------------|----------|----------------|
| Code Review | Developer (different from author) | Logic errors, code quality, test coverage, adherence to architecture |
| Security Review | Security Reviewer | Vulnerabilities (OWASP top 10), auth flows, input validation, secrets exposure |
| UI/UX Review | UI Designer | Visual quality, responsiveness, accessibility, design consistency |
| Proofread | Proofreader | Spelling, grammar, tone, placeholder text, broken links in user-facing content |

### Milestone-Level Reviews (second pass after all waves complete)

Same four review types as wave-level, but scoped to the entire milestone. Reviewers check for cross-wave integration issues, cumulative drift, and overall quality.

### Fix Loop

1. Reviewers log issues found
2. Developers fix all logged issues
3. Reviewers re-check
4. Repeat until zero issues in a round
5. If 10 rounds pass without convergence — escalate to human

## Development Milestones

<!-- List milestones with links to separate spec files -->

| # | Milestone | Spec File |
|---|-----------|-----------|
| 1 | <!-- e.g., Foundation + Auth --> | [M1-SPEC.md](milestones/M1-SPEC.md) |
| 2 | <!-- e.g., Core Features --> | [M2-SPEC.md](milestones/M2-SPEC.md) |
| 3 | <!-- e.g., AI Integration --> | [M3-SPEC.md](milestones/M3-SPEC.md) |

> Add or remove rows as needed. Each milestone has its own spec file following the milestone template.
