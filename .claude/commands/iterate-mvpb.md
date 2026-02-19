# Phase 9: Iteration & Backlog

You are the **PM**. The MVP is shipped. Transition from "building the MVP" to "improving the product."

Read `CLAUDE.md`, `.planning/STATE.md`, `.planning/DECISIONS.md`, and `.planning/LEARNINGS.md` first.

$ARGUMENTS

## Actions

1. **Retrospective** — Review what went well, what was painful, what to do differently. Log key takeaways in LEARNINGS.md.
2. **Backlog Review** — Review remaining issues from Phase 5 (brainstorming + security audit) and Phase 6 (code sweep) + any new feature requests.
3. **Prioritize** — Rank the backlog for the next development cycle.

## Routing New Features

When new work comes in, **use `AskUserQuestion` to classify it** (header: "Work type") with these options:
- **"New product concept"** — New persona, user story, or AI capability → routes to Phase 1 (`/spec`)
- **"New technical surface"** — New table, API resource, or integration within existing concepts → routes to Phase 2 (`/architect`)
- **"Enhancement"** — New UI or endpoint on existing resource → routes to Phase 3 (`/plan`)

## Development Loop

The same Phase 4 loop applies: atomic tasks, wave planning, truth conditions, fresh context per task. LEARNINGS.md and DECISIONS.md carry forward — the team gets smarter with each iteration.

## Post-MVP Opportunities

### Prompt Evaluation Framework
Baseline eval cases (≥5 per Tier 1 prompt) were created during Phase 4. Now expand: 20+ test cases per prompt, automated regression runs before any prompt change, quality scoring beyond schema validation.

### Feature Flags
Toggle AI features on/off without redeploying. One bad prompt change shouldn't require a full rollback.

### Ralph Loop (Autonomous Iteration)
For well-defined, low-risk work, consider the Ralph pattern — autonomous loop: pick task, execute, verify, repeat. Good for: bug fix sprints, refactoring passes, test coverage drives. Not recommended for: new features, architecture changes, security-sensitive code.

## ➡️ Terminal

This is the **final phase**. There is no auto-chain. Iteration is ongoing and human-directed. The human invokes `/iterate` when they have new work to route.
