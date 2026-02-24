# Phase 5: Quality & Security Hardening

You are the **PM / Team Lead** coordinating Security and QA roles. Your goal is a systematic review of the complete application for bugs, security vulnerabilities, UX issues, and missing edge cases.

Read `CLAUDE.md`, `.planning/STATE.md`, `.planning/DECISIONS.md`, `.planning/LEARNINGS.md`, and `docs/ARCHITECTURE.md` first.

$ARGUMENTS

## Agent Teams Parallel Dispatch

The same Agent Teams rules from Phase 4 apply here. You are the orchestrator — delegate, don't do.

- **Steps 1 & 2 run in parallel:** Spawn a QA teammate for the brainstorming session (Step 1) and a Security teammate for the deep audit (Step 2) simultaneously in a single message. Both can work independently — QA reviews for bugs, UX, and polish while Security runs the adversarial audit. Each teammate gets its own worktree:
  ```bash
  WORKTREE_ROOT="../$(basename $(pwd))-worktrees"
  mkdir -p "$WORKTREE_ROOT"
  git worktree add "$WORKTREE_ROOT/qa-brainstorm" -b qa/brainstorm develop
  git worktree add "$WORKTREE_ROOT/security-audit" -b security/audit develop
  ```
  Include the worktree path in each teammate's handoff. Teammates `cd` to their worktree first and must NOT commit `.planning/` file changes.
- **Step 3 (fixes) parallelizes like Phase 4 waves:** When resolving Critical & High issues, spawn developer teammates for independent fixes simultaneously. Each teammate gets a worktree, one issue, fixes, tests, and reports back. Do not work fixes sequentially when they touch different parts of the codebase.
  ```bash
  git worktree add "$WORKTREE_ROOT/fix-issue-42" -b fix/42 develop
  ```
- **Maximum 5 teammates per wave** (same cap as Phase 4). If more than 5 fixes are independent, split into sub-waves of ≤5.
- **Shut down teammates between waves** via `shutdown_request` before spawning the next batch. At phase end, shut down all remaining teammates and call `TeamDelete`.
- **Worktree cleanup:** After merging each fix branch, clean up the worktree: `git worktree remove "$WORKTREE_ROOT/<branch>"`, `git branch -d <branch>`, `git worktree prune`. At phase end, remove any remaining worktrees and prune.
- All other Agent Teams rules (fresh context per task, handoff context, no sequential spawning of independent work, teammate cleanup) carry over from Phase 4.

## Step 1: Brainstorming Session

Review the entire application and log issues in the GitHub Project backlog. Use these labels:

- **`bug`**: Broken flows, incorrect behavior, race conditions
- **`feature`**: Missing expected functionality
- **`ui`**: Layout, responsiveness, accessibility, loading/empty/error states
- **`security`**: Vulnerabilities, missing validation, exposed data
- **`performance`**: Slow queries, re-renders, missing pagination
- **`dx`**: Missing types, unclear code, documentation gaps

**Auth/session behavior review:** Specifically check: Does the access token expire? How long is the expiry? Is there a refresh token mechanism? Does it actually work end-to-end — not just "the code exists" but "the client-side interceptor catches 401s, calls the refresh endpoint, and retries the request"? Is the user experience acceptable when a session expires (redirect to login with a message, not silent data loss or blank screens)?

**Use `AskUserQuestion` to ask the human which areas to prioritize** (header: "Focus areas") — Options: "Full audit (all categories)", "Security-first", "UX & polish priority". Let them select or provide custom focus.

## Step 2: Deep Security Audit

**Adversarial review technique:** Write your list of attack vectors BEFORE reading the code. Then verify each one.

1. **Auth & Sessions** — Password hashing (bcrypt/argon2), session expiry/refresh, failed login rate limiting, secure password reset.
2. **Authorization** — Every endpoint enforces auth. No privilege escalation. Resource ownership verified.
3. **Input Handling** — All inputs validated server-side. SQL injection protection. XSS protection. File upload validation.
4. **Data Protection** — PII encrypted at rest. All traffic HTTPS. No sensitive data in logs. CORS not `*` in production.
5. **Infrastructure** — Dependencies audited. No secrets in source/git history. Rate limiting on public endpoints. Security headers set.
6. **AI-Specific Security** (verify implementation matches ARCHITECTURE.md spec):
   - AI API keys not in client code, network responses, or logs
   - All AI calls route through backend service layer
   - Prompt injection defenses implemented (delimiter tokens, structured messages, output validation, classification step)
   - AI responses validated against schemas before use in business logic
   - Chatbot guardrails enforced server-side, resist bypass attempts
   - Per-user rate limits on AI endpoints
   - AI cost alerts configured
   - Conversation history scoped per-user (no cross-user leakage)
   - Chatbot cannot reveal system prompts or internal details
7. **Script Quality Audit** — Review every shell script in `scripts/` and any Docker entrypoint scripts:
   - Has `set -euo pipefail` at the top
   - No silent error suppression (`2>/dev/null`, `|| true`) without a documented, commented reason
   - Loads env files explicitly — does not assume shell env vars exist
   - Validates required env vars before use (e.g., `[[ -z "$DB_PASSWORD" ]] && echo "error" && exit 1`)
   - Uses correct ports/URLs from the deployment topology — not hardcoded dev defaults like `localhost:3000`
   - Exits non-zero on all failure paths — never prints misleading success messages
   - Has been executed against the containerized stack, not just reviewed

**Severity classification:**
- **Critical** — Blocks MVP. Must fix now.
- **High** — Blocks MVP. Must fix now.
- **Medium** — Log for post-launch. Document risk.
- **Low** — Log for post-launch.

Log every finding as a GitHub issue with label `security` and severity.

## Step 3: Resolve Critical & High Issues

Work through security and critical bug issues using the same task loop from Phase 4 (fresh context per task, branch per fix, test, review, merge). **Spawn developer teammates for independent fixes simultaneously** — group fixes that don't conflict into waves and dispatch them in parallel, exactly as Phase 4 wave execution works.

After each fix is merged, close the corresponding GitHub issue (`gh issue close <number>`) so the project board stays accurate.

## Gate — 🧑 Human

Present findings and resolution to the human:

- [ ] Security audit is complete and documented.
- [ ] All Critical and High issues are resolved.
- [ ] Full test suite still passes after fixes.
- [ ] Human has reviewed the remaining backlog and is comfortable with what's deferred.

Once approved, update STATE.md and DECISIONS.md. Log: **"Approved — moving to Final Code Sweep."**

## ➡️ Auto-Chain

This phase ends with a 🧑 Human gate. **STOP and wait** for the human to explicitly approve the gate checklist. Once approved, immediately begin executing the next phase by reading and following `.claude/commands/sweep-mvpb.md`.
