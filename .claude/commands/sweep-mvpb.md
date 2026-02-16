# Phase 6: Final Code Sweep

You are the **PM / Team Lead** coordinating the builders' final review. Your goal is a comprehensive bug-finding pass by the people who built the system — they see integration seams, architectural drift, and "works but wrong" patterns that Security and QA miss.

Read `CLAUDE.md`, `.planning/STATE.md`, `.planning/DECISIONS.md`, `.planning/LEARNINGS.md`, and `docs/ARCHITECTURE.md` first.

$ARGUMENTS

## Why This Phase Exists

During Phase 4, each task was built in isolation with fresh context. The Developer who built the auth system never saw the AI service layer. The one who built the API endpoints never saw the admin panel. Phase 5 caught security vulnerabilities and UX bugs — but only the builders can spot architectural drift, inconsistent patterns across modules, and integration seams between components built weeks apart.

This phase gives the Architect and Developers one complete pass through the finished codebase as a whole — the first time anyone has looked at the entire system together.

## Agent Teams Parallel Dispatch

The same Agent Teams rules from Phase 4 apply here. You are the orchestrator — delegate, don't do.

- **Step 1 runs 3 teammates in parallel**: Architect + 2 Developers, each covering a different review domain. All spawned simultaneously in a single message.
- **Step 2 (fixes) parallelizes like Phase 4 waves**: Independent fixes spawned simultaneously (max 5 per wave), dependent fixes sequenced.
- **Shut down teammates between steps and waves** via `shutdown_request`. At phase end, shut down all remaining teammates and call `TeamDelete`.

## Step 1: Builders' Review (3 teammates, spawned simultaneously)

### Teammate 1: Architect — Structural Review

The Architect reviews the entire codebase against `docs/ARCHITECTURE.md`:

1. **Architectural drift** — Does the implementation still match the architecture doc? Flag any component, data flow, or API contract that diverged during development. Common drift: endpoints added without updating ARCHITECTURE.md, data model fields added ad-hoc, middleware ordering changed.
2. **Pattern consistency** — Are the same patterns used everywhere? Look for: inconsistent error handling across routes, mixed data fetching strategies (some components use server actions, others use API calls), inconsistent validation approaches, mixed naming conventions.
3. **Dead code and leftovers** — Unused imports, commented-out code, TODO/FIXME/HACK comments left behind, unused utility functions, orphaned components.
4. **Dependency review** — Are all dependencies actually used? Are there duplicate libraries serving the same purpose (e.g., both `dayjs` and `date-fns`)?
5. **Data model integrity** — Do all relationships make sense end-to-end? Are there orphaned foreign keys, missing cascades, or indexes that should exist for common query patterns?

Output: GitHub issues for each finding, labeled `architecture` or `code-quality`.

### Teammate 2: Developer — Integration Seam Review

A Developer reviews the boundaries between components that were built in different waves:

1. **API contract alignment** — Do frontend components send exactly what the API expects? Do they handle all possible response shapes (success, validation error, auth error, server error)? Check every fetch/API call against the actual endpoint implementation.
2. **State management consistency** — Is client-side state kept in sync with server state? After mutations, is the UI refreshed correctly? Are there stale cache issues?
3. **Error propagation** — Trace errors from origin to user-facing display. Does a database constraint violation produce a helpful user message or a generic 500? Does an AI API timeout show a useful fallback or a blank screen?
4. **Edge cases at boundaries** — Empty states (no data yet), loading states (slow network), concurrent access (two tabs), large data sets (pagination working?), special characters in user input flowing through the whole stack.
5. **Environment variable completeness** — Is `.env.example` complete? Does every env var referenced in code have a matching entry? Are there env vars in `.env.example` that are no longer used?

Output: GitHub issues for each finding, labeled `bug` or `integration`.

### Teammate 3: Developer — Functional Sweep

A Developer systematically walks through every user-facing feature and tries to break it:

1. **Happy path verification** — Walk through every user story from the spec. Does it work end-to-end? Not "do the tests pass" but "does this actually feel right when you use it?"
2. **Input boundary testing** — For every form and input: empty submission, maximum length, special characters, rapid repeated submission, pasting vs typing.
3. **Auth boundary testing** — Access every authenticated route without auth (direct URL). Access admin routes as a regular user. Test token expiry — does refresh work or does the user get kicked out silently?
4. **AI feature robustness** — Send edge-case inputs to every AI feature: very long text, empty text, text in other languages, adversarial prompts. Does the fallback work when you simulate API failure?
5. **Navigation completeness** — Click every link, button, and interactive element. Are there dead links? Buttons that do nothing? Pages that 404?
6. **Keyboard navigation** — Tab through every page using keyboard only. Can you reach every interactive element? Can you submit forms? Can you open and close modals? Is there a visible focus indicator on every focusable element? Is there a "Skip to main content" link?

Output: GitHub issues for each finding, labeled `bug` or `ux`.

## Step 2: Fix Critical and High Issues

Work through the issues found in Step 1, using the same task loop from Phase 4:
- Group independent fixes into waves
- Spawn developer teammates simultaneously for each wave
- Each teammate: branch → fix → test → commit → report back
- PM reviews, merges, and closes the GitHub issue (`gh issue close <number>`)

Priority order:
1. **Bugs** — Broken functionality comes first
2. **Integration issues** — Seam problems that affect user experience
3. **Architectural drift** — Update ARCHITECTURE.md or fix code to match
4. **Code quality** — Dead code, inconsistent patterns, missing indexes

Medium and Low issues that don't affect core functionality: log them for Phase 8 (Iteration), don't block deployment.

## Step 3: Regression Verification

After all fixes are merged:
1. Run the full test suite — all tests must pass.
2. Run Playwright E2E suite — all truth conditions from all milestones still hold.
3. Verify the Docker production build still works: `docker compose -f docker-compose.prod.yml up --build` → all services healthy.

If anything broke during fixes, fix it before proceeding.

## Gate — 🧑 Human

Present the sweep findings and resolutions to the human:

- [ ] Architect structural review complete — architectural drift documented and resolved.
- [ ] Integration seam review complete — API contract mismatches and boundary bugs fixed.
- [ ] Functional sweep complete — all user stories verified end-to-end.
- [ ] All Critical and High issues from the sweep are resolved.
- [ ] Full test suite and Playwright E2E suite pass.
- [ ] Production Docker build verified after fixes.
- [ ] Remaining Medium/Low issues logged for Phase 8.

Once approved, update STATE.md. Log: **"Approved — moving to Deployment & Launch Prep."**

## ➡️ Auto-Chain

This phase ends with a 🧑 Human gate. **STOP and wait** for the human to explicitly approve the gate checklist. Once approved, immediately begin executing the next phase by reading and following `.claude/commands/deploy-mvpb.md`.
