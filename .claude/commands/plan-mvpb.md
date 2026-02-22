# Phase 3: Task Breakdown & Planning

You are the **PM**. Your goal is to convert all requirements into trackable GitHub issues with milestones, truth conditions, and wave plans.

Read `CLAUDE.md`, `.planning/STATE.md`, `.planning/DECISIONS.md`, `docs/PRODUCT_SPEC.md`, and `docs/ARCHITECTURE.md` first.

$ARGUMENTS

## Step 1: Define Milestones & Truth Conditions

Propose version milestones. **Use the `AskUserQuestion` tool to confirm the milestone plan with the human** — present 2-3 options for milestone scope/ordering and let them choose or customize.

Default milestone structure (adapt based on the product):
- **v0.1 — Foundation**: Project setup, CI/CD, database, auth
- **v0.2 — Core Feature + AI**: #1 user workflow end-to-end, AI service layer, prompt management
- **v0.3 — Smart Features**: Suggestions, chatbot, remaining user stories
- **v0.4 — Admin & Analytics**: Admin panel, AI usage tracking, monitoring
- **v0.5 — Polish & Harden**: Edge cases, error handling, security hardening
- **v1.0 — Launch Ready**: Production deployment, monitoring, demo

Ask the human:
- "Does this milestone breakdown work for your project?" (header: "Milestones") — Options: "Looks good, proceed", "I want fewer milestones (combine some)", "I want to reorder priorities"

For EACH milestone, define **truth conditions** — observable behaviors that must be true when complete. These are not tasks; they are proof the milestone works. Example:

```
v0.2 Truth Conditions:
- [ ] A new user can register, verify email, and log in.
- [ ] A logged-in user can trigger the core AI workflow and receive a valid result.
- [ ] If the AI API is down, the user sees a graceful fallback (not a crash).
- [ ] The AI service layer logs the API call with token count and latency.
- [ ] Golden datasets exist for all Tier 1 AI prompts (≥5 eval cases each) and all eval tests pass baseline.
- [ ] All truth conditions can be verified by running the test suite.
```

**Mandatory rule for milestones that introduce or modify AI prompts:** The truth conditions MUST include a golden dataset eval condition — "Golden datasets exist for all Tier 1 AI prompts in this milestone (≥5 eval cases each, stored in `prompts/evals/`) and all eval tests pass baseline." This is not optional. If this truth condition is missing, the milestone plan is incomplete. This prevents the eval framework from being silently deferred — if the golden dataset doesn't exist, the truth condition fails, and the milestone is blocked.

## Step 2: Create GitHub Issues (Atomic Sizing)

Log EVERY requirement as a GitHub issue with: title, labels, milestone, acceptance criteria, dependencies.

**Atomic sizing rules — each issue must be completable in a single fresh session:**

- **Max scope**: ≤ 3 logical units (a unit = cohesive files for one concern, e.g., route + handler + migration)
- **Context budget**: Task + source files + CLAUDE.md ≤ 50% context window
- **Single responsibility**: One thing per task. Never "build the whole auth system."
- **Testable in isolation**: If you can't write a test for it, the task is too vague.

> Anti-pattern: "Implement user authentication" → Too big.
> Correct: "Create users table migration" → "Add password hashing utility" → "Build POST /api/auth/register" → ...

**DevOps task acceptance criteria must include execution.** Tasks that produce Docker, nginx, or deployment artifacts are not done when the file is written — they are done when the artifact has been executed successfully. "Write the Dockerfile" is not a valid task. "Write and build the Dockerfile, verify the image starts and serves the app" is. Include execution-based acceptance criteria for every infra task: `docker build` must succeed, `docker compose up` must reach healthy, scripts must run without errors against the containerized stack.

## Step 3: Wave Planning

For each milestone, organize issues into **waves**. **Spawn an Architect teammate to advise on wave composition** — the Architect knows the codebase structure and can assess which tasks are truly independent, which files each task will touch, and what the merge-conflict risk is. Give the Architect the task list and ARCHITECTURE.md; the Architect returns a dependency graph, file-touch map, and overlap risk assessment.

1. **Using the Architect's assessment**, analyze dependencies — which tasks are independent? Which depend on others?
2. Group into waves — independent tasks in the same wave, dependent tasks in later waves.
3. **Same-file overlap is risk-assessed** (worktree isolation prevents filesystem conflicts, but merge conflicts may still occur):
   - **Low risk** (independent additions — e.g., two new files in the same directory): OK in the same wave.
   - **Medium risk** (same area — e.g., two tasks adding different API routes to the same router file): prefer sequential waves.
   - **High risk** (same function/component — e.g., two tasks modifying the same React component or utility): must be in sequential waves.
4. **Maximum 5 tasks per wave.** If more than 5 independent tasks exist, split into sub-waves of ≤5. This caps concurrent teammates to prevent token burn and rate-limit hits.
5. Final wave of each milestone is always **verification** (QA + Security review).
6. Each wave entry: `- [ ] #7 — Build POST /api/auth/register endpoint`

Document wave plans in `.planning/STATE.md`.

## Gate — 🧑 Human

Present the plan to the human:

- [ ] All requirements have corresponding GitHub issues.
- [ ] Issues are assigned to milestones and sized atomically.
- [ ] Truth conditions are defined for each milestone.
- [ ] Wave plans are defined for each milestone.
- [ ] First milestone issues are prioritized and in `To Do`.
- [ ] Human has reviewed and approved the plan.

Once approved, update `.planning/STATE.md`. Log: **"Approved — moving to Development."**

## ➡️ Auto-Chain

This phase ends with a 🧑 Human gate. **STOP and wait** for the human to explicitly approve the gate checklist. Once approved, immediately begin executing the next phase by reading and following `.claude/commands/build-mvpb.md`.
