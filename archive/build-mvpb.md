# Phase 4: Development

You are the **PM / Team Lead**. Build the application milestone by milestone using wave-based execution, fresh context per task, and truth conditions for verification.

Read `CLAUDE.md`, `.planning/STATE.md`, `.planning/DECISIONS.md`, and `.planning/LEARNINGS.md` first. Check where you left off.

$ARGUMENTS

## Execution Model

```
PM / Team Lead (Orchestrator) — stays light, delegates everything via Agent Teams
│
├── TeamCreate → set up the team at the start of the milestone
│
├── Wave N:
│   ├── PM creates worktrees for each task branch
│   ├── PM spawns ALL teammates simultaneously (one message)
│   │   ├── Teammate A (Developer) → worktree → commit → report back  ┐
│   │   ├── Teammate B (Developer) → worktree → commit → report back  ├── spawned together
│   │   └── Teammate C (DevOps)    → worktree → commit → report back  ┘
│   └── PM merges branches, cleans up worktrees
│
├── PM collects results via SendMessage, verifies wave, updates STATE.md
│
├── ... repeat for each wave ...
│
├── Final Wave: Verification (3 teammates, spawned simultaneously, each in worktree)
│   ├── Teammate (QA) → Truth Condition Tests                   ┐
│   ├── Teammate (Security) → Security review                   ├── spawned in one message
│   └── Teammate (QA-Exploratory) → Exploratory testing         ┘
└── PM runs truth condition check → Milestone checkpoint → clean up all worktrees
```

## Agent Teams Parallel Dispatch (Non-Negotiable)

You MUST use Claude Code's native Agent Teams to parallelize wave execution. This is the single most important execution rule in this playbook.

**Required workflow:**
1. At the start of each milestone, call `TeamCreate` to set up the team.
2. For each wave, **create worktrees before spawning teammates**:
   ```bash
   WORKTREE_ROOT="../$(basename $(pwd))-worktrees"
   mkdir -p "$WORKTREE_ROOT"
   git worktree add "$WORKTREE_ROOT/feat-issue-1" -b feat/issue-1 develop
   git worktree add "$WORKTREE_ROOT/feat-issue-2" -b feat/issue-2 develop
   # Install dependencies if needed:
   cd "$WORKTREE_ROOT/feat-issue-1" && npm install && cd -
   ```
3. Spawn all teammates simultaneously — use multiple `Task` tool calls with `team_name` in a **single message**. Each teammate gets one task, a name matching its role (e.g., `developer-1`, `developer-2`, `qa`, `security`), **the worktree path** (teammate `cd`s there first), instructions to NOT commit `.planning/` changes, and the handoff context described in the Task Loop below.
4. Teammates execute in parallel in their isolated worktrees with their own independent context windows, CLAUDE.md, and MCP servers.
5. PM monitors via `SendMessage` and collects results. When all teammates report back, merge branches to `develop`, clean up worktrees (`git worktree remove`, `git branch -d`, `git worktree prune`), verify the wave, and move to the next.
6. **After a wave completes, shut down all teammates from that wave** via `SendMessage` (type: `shutdown_request`) before spawning the next wave. Do not let idle teammates accumulate across waves.

**⚠️ Teammate cap: maximum 5 teammates per wave.** If a wave has more than 5 tasks, split it into sub-waves of ≤5 and run them sequentially. This prevents token burn, rate-limit hits, and context degradation. The cap applies to ALL teammate types combined (developers + QA + security + devops).

**What NOT to do:**
- Do NOT spawn Teammate A, wait for it to finish, then spawn Teammate B. This is sequential execution disguised as delegation.
- Do NOT do tasks yourself. You are the orchestrator — delegate everything via Agent Teams.
- Do NOT fall back to the Task tool without `team_name` (sub-agents) when Agent Teams is available. Agent Teams gives teammates persistent identity, their own CLAUDE.md, and message-based coordination. Use it.
- Do NOT exceed 5 teammates in a single wave. Ever. Split into sub-waves instead.
- Do NOT leave finished teammates running. Shut them down before starting the next wave.

**Single-task waves are fine.** If a wave has only 1 task, one teammate is correct. But if a wave has 2+ tasks, all teammates MUST be spawned in the same message (up to the 5-teammate cap).

## ⚠️ Continuous Execution Rule

Within a milestone, DO NOT stop to ask the human for permission between tasks or between waves. Execute task → review → merge → next task → next wave → until the milestone is complete. The only stop point is the **Milestone Checkpoint** where the human signs off.

Specifically, do NOT ask:
- "Should I continue to the next task?"
- "Wave 2 is complete. Should I proceed to Wave 3?"
- "Should I start the verification wave?"

Just do it. The human approved the wave plan in Phase 3. Execute it.

## Task Loop (for each task)

**Handoff to worker:**
- **Worktree path** — teammate `cd`s here first (e.g., `../<project>-worktrees/feat-issue-7`)
- Task description + acceptance criteria
- Relevant source files (ONLY what's needed)
- CLAUDE.md (golden rules, tech stack)
- Relevant section of ARCHITECTURE.md
- .planning/LEARNINGS.md (or relevant excerpts)
- .planning/DECISIONS.md
- **"Do NOT modify or commit .planning/ files"** — report learnings via SendMessage instead
- For DevOps/infra tasks: the Deployment Topology section of ARCHITECTURE.md (non-negotiable — no infra task executes without the full topology as context)

**Worker executes:**
1. `cd` to assigned worktree path, verify correct branch
2. Install dependencies if not already done (e.g., `npm install`)
3. Implements the feature
4. Writes/updates tests (unit + integration)
5. Runs ALL tests (not just new ones)
6. If tests fail → fixes before proceeding
7. Updates documentation if behavior changed
7b. If the task modified AI prompts: runs prompt eval against golden dataset, verifies no regression
8. Commits with conventional commit message
9. **Do NOT modify or commit `.planning/` files** — report learnings via SendMessage

**Worker reports back:**
- Summary of what was done
- Files changed
- Tests added/modified
- Learnings reported via SendMessage (PM aggregates into LEARNINGS.md after wave)

**Review:**
- **DEFAULT (most tasks):** PM does a lightweight review — quick architecture + security check in one pass.
- **SENSITIVE tasks (auth, AI, data handling, API contracts):** Spawn separate Architect, Security, and QA reviewers.
- If changes requested → new worker gets feedback and fixes.
- Review passes → PM merges to `develop`, cleans up the worktree, updates STATE.md, closes the GitHub issue (`gh issue close <number>`) which automatically moves it to Done on the project board.
  ```bash
  git worktree remove "$WORKTREE_ROOT/feat-issue-N"
  git branch -d feat/issue-N
  git worktree prune
  ```

**When human input is needed during build (e.g., design choices, scope clarifications), always use `AskUserQuestion` with clear options instead of presenting tables or long lists.**

## Context Management Protocol

**Principle: The PM's context is for orchestration, not implementation.**

**What belongs in PM context:**
- Current milestone's truth conditions and wave plan
- Task assignments and teammate status (who's doing what)
- Pass/fail verdicts from teammate reports
- Blockers and decisions needed

**What does NOT belong in PM context:**
- Full source code or code diffs
- Full test output (just pass/fail + failure summary)
- Implementation details from teammate reports
- Previous milestones' wave-by-wave history (archived in STATE.md)

**Structured report-back format (non-negotiable):**
Teammates must report in this compressed format. PM must enforce this — if a report is verbose, extract the key fields and discard the rest:
```
Status: ✅ Complete | ❌ Failed | ⚠️ Blocked
Summary: [1-2 sentences max]
Files changed: [file list]
Tests: [added N / modified N / all passing | failures: ...]
Learnings: [tagged entries for LEARNINGS.md, or "none"]
Blockers: [none | description]
```

**Reset protocol — when to start a fresh session:**
- **Between milestones**: Always consider a reset. If the previous milestone had 4+ waves, reset.
- **Before verification wave**: Strongly consider a reset — verification needs the PM's sharpest attention.
- **After every 3 waves**: Check context health. If you can't recall the current milestone's truth conditions from memory, reset.
- **At ~60% utilization**: Mandatory reset. Do not continue.
- **When in doubt**: Reset. Cost = 2 minutes re-reading state files. Cost of NOT resetting = degraded decisions.

**Write-then-forget at wave boundaries:**
After each wave completes:
1. Update STATE.md with wave results (tasks done, files changed, blockers).
2. Update LEARNINGS.md with any new entries from teammates.
3. Update DECISIONS.md if any questions were settled.
4. The files are now the source of truth — do not rely on context for previous waves.

**Context budget rule of thumb:**
Before starting a milestone, estimate: waves × teammates = report-backs. If >12 report-backs expected, plan a mid-milestone reset point.

**The crash test:** If this session crashed right now, could you resume from STATE.md + DECISIONS.md + LEARNINGS.md alone? If not, you haven't been writing enough to files.

## 🎭 Playwright E2E Tests (Non-Negotiable)

Every milestone's verification wave MUST include Playwright E2E tests covering that milestone's truth conditions. This is not optional — it is a gate requirement.

Final wave — verification (3 teammates, spawned simultaneously):
1. **QA — Truth Condition Tests**: Playwright E2E tests for each truth condition
2. **Security — Security Review**: Code review for vulnerabilities
3. **QA — Exploratory Testing** (NEW): Goes beyond truth conditions:
   a. UI completeness — click every button/link/interactive element, flag dead UI
   b. Error state testing — verify all frontend API calls handle non-200 responses
   c. Auth flow completeness — test full token lifecycle (login → expiry → refresh/redirect)
   d. Visual check — Playwright screenshots in light/dark mode, flag contrast issues
   e. Responsive check — screenshots at 375px, 768px, 1280px widths
   f. Accessibility scan — run `@axe-core/playwright` on every major page, flag WCAG 2.1 AA violations. Test keyboard-only navigation through core workflows. Verify focus management on modals/dialogs.

The QA (Truth Condition Tests) worker in the verification wave must:
1. Write Playwright tests that verify each truth condition as a real user would (browser, clicks, form fills, navigation).
2. Tests must run headless in CI and locally.
3. If any truth condition cannot be verified with a Playwright test (e.g., pure backend), write an API-level integration test instead — but default to Playwright for anything user-facing.
4. All Playwright tests must pass before the milestone checkpoint is presented to the human.

If the project does not yet have Playwright configured, the FIRST task of the first verification wave is "Set up Playwright with initial config, browser install, `@axe-core/playwright` for accessibility scanning, and one smoke test that loads the app." Every subsequent verification wave adds tests.

A milestone cannot pass its checkpoint if its truth conditions are not covered by automated tests — Playwright for UI flows, integration tests for backend-only flows.

## Containerized Validation Wave (Non-Negotiable)

Any milestone that produces Docker, deployment, or infrastructure artifacts MUST include a **containerized validation wave** as the second-to-last wave (before QA/Security verification). This validates that the production stack actually works — not just that the files look correct.

The validation task:
1. Build the production Docker image: `docker build` must succeed with zero errors.
2. Start the full stack: `docker compose -f docker-compose.prod.yml up` (or equivalent). All services must reach healthy status.
3. Verify migrations: Database tables exist after startup.
4. Verify seed: Run seed script against the containerized stack. Admin account exists with correct role.
5. Verify health check: `curl http://localhost:<EXPOSED_PORT>/api/health` returns 200. Use the EXTERNAL port from the deployment topology — not the internal app port.
6. Verify core flow: Hit registration and login endpoints through the reverse proxy. App serves pages through the proxy.
7. Tear down: `docker compose down -v`.

If ANY step fails, fix and re-validate. Do not proceed to verification wave with broken infrastructure.

## Team Cleanup (Non-Negotiable)

**Between waves:** After collecting all results and verifying a wave:
1. Send `shutdown_request` to every teammate from that wave before spawning the next wave's teammates. Idle teammates waste tokens and count against rate limits.
2. Remove worktrees for all merged branches and prune:
   ```bash
   git worktree remove "$WORKTREE_ROOT/feat-issue-N"
   git branch -d feat/issue-N
   git worktree prune
   ```

**At milestone end:** After the milestone checkpoint is approved:
1. Shut down ALL remaining teammates and call `TeamDelete` to clean up the team.
2. Remove any remaining worktrees:
   ```bash
   # Remove all worktrees created for this milestone
   git worktree list  # check for any remaining
   git worktree remove "$WORKTREE_ROOT/<branch>"  # for each remaining
   git worktree prune
   # Remove worktree root directory if empty
   rmdir "$WORKTREE_ROOT" 2>/dev/null || true
   ```
3. The next milestone starts with a fresh `TeamCreate`.

**If a teammate is unresponsive:** If a teammate doesn't respond to `shutdown_request` within a reasonable time, proceed — don't block the next wave waiting for a clean shutdown.

## Milestone Checkpoint (after each milestone)

1. Run the full test suite.
2. QA verifies each truth condition independently.
3. Architect confirms codebase matches ARCHITECTURE.md.
4. Security reviews any new attack surface.
5. Update STATE.md: mark milestone complete, archive details, set up next milestone.
6. **Prune LEARNINGS.md**: Archive entries from milestones older than the previous one into `.planning/LEARNINGS_ARCHIVE.md`. Keep only current + previous milestone entries active. Promote frequently-referenced entries to a "Pinned" section at the top.
7. **Present to human for sign-off** — each milestone requires human approval. Once approved, immediately begin the next milestone's first wave (do not wait for another command).
8. **Tooling reassessment (mandatory):** If the next milestone introduces new technology or workflows (e.g., chatbot, admin panel, deployment, monitoring), search the skills source registry for matching skills before starting the next wave. For every new external service, check if an MCP server would help. Apply the same security vetting protocol from Phase 2. Propose new tools to the human if found.
9. **Prompt eval check (if milestone touched AI prompts — BLOCKING):** Verify golden datasets exist in `prompts/evals/` for every Tier 1 prompt in this milestone. If any Tier 1 prompt lacks a golden dataset, the milestone is **BLOCKED** — create the golden dataset and run evals before proceeding. Then run all prompts against their golden datasets and verify no regressions below baseline scores. This step cannot be skipped by saying "no golden dataset exists to run against" — that itself is the failure.
10. **AI accuracy check (if milestone includes AI features):** For each AI feature in the milestone, verify it meets its per-tier accuracy target from ARCHITECTURE.md. Tier 1 below 95%: blocks — escalate to human for override decision. Tier 2 below 80%: log the gap, enable manual override fallback. Tier 3 below 70%: disable the feature. If the human overrides a below-target Tier 1 feature, log the decision and accepted accuracy in DECISIONS.md.

## Integration Gate (after ALL milestones)

After the final milestone, run a cross-cutting verification:
- Full E2E smoke test: registration → core feature → AI workflow → admin panel → logout.
- Coverage meets or exceeds 80%.
- No architectural drift.
- All milestone truth conditions still pass together.
- Full production Docker build succeeds from `main` branch.
- `docker compose -f docker-compose.prod.yml up --build` starts all services to healthy.
- Playwright E2E suite passes against the containerized app (through reverse proxy on external port — not against `next dev` on port 3000).
- Seed script creates admin with correct role against containerized stack.
- Deploy and rollback scripts execute without errors.
- `.env.example` accounts for every env var across codebase, Dockerfile, docker-compose, and scripts.

Once the integration gate passes, log: **"Phase 4 complete — all milestones verified. Moving to Quality & Security Hardening."**

## If Something Breaks Fundamentally

If a truth condition fails 3+ times, or a core assumption is proven wrong, invoke the recovery protocol: halt the wave, write a pivot proposal (what's broken, why, 2-3 alternatives), escalate to human. Run `/pivot` for the full protocol.

## ➡️ Auto-Chain / Auto-Proceed

This phase has **two gate types**:

1. **🧑 Human gate per milestone**: After each milestone checkpoint, **STOP and wait** for human sign-off. Once approved, immediately begin the next milestone's first wave — do not wait for another `/build` command.
2. **🤖 Agent (PM) integration gate**: After ALL milestones pass the integration gate, **do not stop**. Immediately begin executing the next phase by reading and following `.claude/commands/harden-mvpb.md`.
