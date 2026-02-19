# Phase 7: Playwright Acceptance Loop

> **Browser-based apps only.** This phase applies to projects with a browser-based UI. If the project has no browser UI (CLI, API, backend service), skip this phase and proceed directly to Phase 8 by reading `.claude/commands/deploy-mvpb.md`.

You are the **PM / Team Lead** coordinating exhaustive Playwright acceptance testing. Your goal is 3 consecutive clean QA passes with zero issues before the app ships.

Read `CLAUDE.md`, `.planning/STATE.md`, `.planning/DECISIONS.md`, `.planning/LEARNINGS.md`, and `docs/ARCHITECTURE.md` first.

$ARGUMENTS

## Why This Phase Exists

Playwright E2E testing was consistently deprioritized during Phase 4 verification waves — the PM conserves context budget by deferring heavyweight testing. This phase makes Playwright acceptance a hard gate with a clear exit criterion: **3 consecutive clean passes with zero issues logged.** It cannot be skipped or deferred.

## The Ralph Loop

```
┌─────────────────────────────────────────────────────────┐
│  RALPH LOOP — Playwright Acceptance                     │
│                                                         │
│  1. PM spawns QA Tester teammate (in worktree)          │
│                                                         │
│  2. Tester: Full Playwright pass                        │
│     ├── Click every link, button, interactive element   │
│     ├── Test every form (valid, invalid, empty, edge)   │
│     ├── Test every user flow end-to-end                 │
│     ├── Test every permutation and combination          │
│     ├── Responsive check (375/768/1280px)               │
│     ├── Accessibility scan (axe-core, keyboard nav)     │
│     ├── Auth boundaries (expired tokens, role checks)   │
│     ├── Error states (API failures, loading, empty)     │
│     └── Log ALL issues as GitHub issues                 │
│                                                         │
│  3. Tester reports findings to PM                       │
│     └── If zero issues → increment clean pass counter   │
│         If any issues → reset clean pass counter to 0   │
│                                                         │
│  4. PM assigns developers to fix (parallel waves)       │
│     ├── Same wave rules as Phase 4 (max 5 per wave)     │
│     ├── Developers fix → test → commit → report back    │
│     └── PM merges, cleans up worktrees                  │
│                                                         │
│  5. Shut down all teammates, go to step 1               │
│                                                         │
│  EXIT: 3 consecutive clean passes with ZERO issues      │
└─────────────────────────────────────────────────────────┘
```

## Agent Teams Parallel Dispatch

The same Agent Teams rules from Phase 4 apply here. You are the orchestrator — delegate, don't do.

- **QA Tester gets a worktree** for running Playwright tests:
  ```bash
  WORKTREE_ROOT="../$(basename $(pwd))-worktrees"
  mkdir -p "$WORKTREE_ROOT"
  git worktree add "$WORKTREE_ROOT/qa-acceptance" -b qa/acceptance develop
  ```
  Include the worktree path in the Tester's handoff. Tester `cd`s to the worktree first and must NOT commit `.planning/` file changes.
- **Developer fix waves** parallelize like Phase 4: Group independent fixes, spawn developer teammates simultaneously (max 5 per wave). Each developer gets a worktree:
  ```bash
  git worktree add "$WORKTREE_ROOT/fix-issue-N" -b fix/N develop
  ```
- **Shut down all teammates between passes** via `shutdown_request` before starting the next pass. At phase end, shut down all remaining teammates and call `TeamDelete`.
- **Worktree cleanup:** After merging each fix branch, clean up: `git worktree remove "$WORKTREE_ROOT/<branch>"`, `git branch -d <branch>`, `git worktree prune`. At phase end, remove any remaining worktrees and prune.
- All other Agent Teams rules (fresh context per task, handoff context, no sequential spawning of independent work, teammate cleanup) carry over from Phase 4.

## Rules

1. **Tester never fixes.** The QA Tester only tests and logs. Developers fix.
2. **Developers never test their own fixes.** The Tester validates in the next pass.
3. **Clean pass counter resets on any issue.** If pass 2 finds even 1 issue, the counter goes back to 0.
4. **Every pass is exhaustive.** The Tester must click every link, test every form, try every path. No shortcuts, no "I already checked that last time."
5. **Issues are GitHub issues.** Logged with labels (`bug`, `ui`, `accessibility`, `ux`) so they're trackable.
6. **Same Agent Teams rules apply.** Worktree isolation, max 5 teammates per fix wave, shutdown between waves, teammate cleanup.

## Tester Pass Scope

Each pass covers ALL of the following — hand this list to the QA Tester teammate:

**Qualitative (does it work correctly?):**

1. **Navigation completeness** — Click every link, button, nav item, and interactive element. Flag dead links, buttons without handlers, 404 pages.
2. **Form testing** — Every form with: valid input, empty submission, max-length input, special characters, rapid repeated submission.
3. **User flow testing** — Walk through every user story from the product spec end-to-end, including edge cases and alternative paths.
4. **Auth boundary testing** — Access authenticated routes without auth. Access admin routes as user. Test token expiry and refresh. Test logout.
5. **Error state testing** — Verify every API call handles non-200 responses. Test what the user sees on 401, 403, 500.
6. **AI feature testing** — Edge-case inputs to every AI feature: very long text, empty text, other languages, adversarial prompts. Verify fallbacks.
7. **Responsive testing** — Playwright screenshots at 375px, 768px, 1280px. Flag layout breaks.
8. **Accessibility testing** — axe-core scan on every page. Keyboard-only navigation through all core workflows. Focus management on modals/dialogs. Visible focus indicators.
9. **Loading and empty states** — Verify loading indicators exist. Verify empty states have appropriate messaging.

**Quantitative (does it meet measurable thresholds?):**

10. **Page load performance** — Measure time-to-interactive for every major page using Playwright's `performance.timing` API. Flag any page over 3s on simulated 4G (`page.emulateNetworkConditions`). Record actual values.
11. **Core Web Vitals** — Capture LCP, CLS, and INP on every major page via `web-vitals` or PerformanceObserver. Thresholds: LCP < 2.5s, CLS < 0.1, INP < 200ms. Log values even if passing.
12. **API response times** — Intercept every API call during user flow tests (`page.on('response')`). Flag any endpoint over 1s. Record p50 and p95 for each endpoint.
13. **Console errors** — Capture all `console.error` and `console.warn` output during every test (`page.on('console')`). Zero console errors is the target. Warnings are logged but non-blocking.
14. **Accessibility score** — Run axe-core on every page and record the violation count per page. Target: zero violations. Track count across passes to confirm it trends to zero.
15. **Network payload** — Measure total transfer size per page load using `page.on('response')`. Flag any page over 2MB total transfer. Record per-page totals.

## Tracking

Track progress in STATE.md:
```markdown
## Phase 7 — Playwright Acceptance Loop
Clean pass counter: [0/3]
Pass 1: [N issues found — list GitHub issue numbers]
  Fix wave 1: [issues fixed]
  Fix wave 2: [issues fixed]
Pass 2: [N issues found — list GitHub issue numbers]
  Fix wave 1: [issues fixed]
Pass 3: [0 issues — clean pass 1/3]
Pass 4: [0 issues — clean pass 2/3]
Pass 5: [0 issues — clean pass 3/3] ✅ EXIT
```

## Gate — 🧑 Human

Present the acceptance results to the human:

- [ ] QA Tester has made 3 consecutive clean Playwright passes with zero qualitative or quantitative issues.
- [ ] All issues found during the loop are resolved and closed.
- [ ] Quantitative metrics recorded and thresholds met: LCP < 2.5s, CLS < 0.1, INP < 200ms, zero console errors, zero axe-core violations, no page over 2MB transfer, no API endpoint over 1s.
- [ ] Full test suite passes.
- [ ] Production Docker build verified after all fixes.

Once approved, update STATE.md. Log: **"Approved — moving to Deployment & Launch Prep."**

## ➡️ Auto-Chain

This phase ends with a 🧑 Human gate. **STOP and wait** for the human to explicitly approve the gate checklist. Once approved, immediately begin executing the next phase by reading and following `.claude/commands/deploy-mvpb.md`.
