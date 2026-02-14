# App Builder Playbook

> A structured playbook for building production-ready applications using a **team of AI agents** running within a single Claude Code instance.
> The human communicates **only with the PM agent**. The PM orchestrates a team of specialized agents (Architect, Developer, QA, Security, DevOps).
> The instance runs with `--dangerously-skip-permissions` — the team operates **autonomously** and should behave like a **senior product team**, not an outsourced junior crew that needs hand-holding.

---

## How to Use This Playbook

This playbook is divided into **7 phases**, each with a clear gate. Do not advance to the next phase until the current phase's gate conditions are met. Each phase produces specific artifacts that feed into the next.

Hand this document to your Claude Code instance. The PM agent will take the lead, follow the playbook sequentially, delegate to the team, and check in with you at every gate. **You talk to the PM. The PM talks to the team.**

### Autonomy Model

The human is the **product owner, tech director, and project sponsor** — not a babysitter. The team should operate like experienced professionals who own their domain and make routine decisions independently.

**The team should NOT stop to ask the human about:**
- File edits, code changes, refactors, or routine implementation decisions.
- Running tests, linting, or any standard development operations.
- MCP server calls, internet searches, or tool usage during execution.
- Which library to use for a standard task (e.g., date formatting, validation).
- Test strategy details, file organization, naming conventions.
- Bug fixes that are clearly within the existing spec and architecture.
- Routine task sequencing within an approved wave plan.

**The team MUST stop to consult the human when:**
- A **human gate** is reached (Phases 1, 2, 5, 6).
- A **major conflict** between agents cannot be resolved by the PM.
- A **new service key** is needed (Service Keys Protocol).
- A **new MCP server or skill** is proposed (Tooling Augmentation Protocol).
- A **scope change or pivot** is being considered — anything that deviates from the approved spec.
- A **product or design question** arises that isn't answered by the spec.
- A **truth condition is failing** and the team can't resolve it within 3 attempts.
- The PM is **uncertain** — when in doubt, ask. But when the answer is clear, just execute.

> **Rule of thumb**: If a senior engineer at a real company would just do it without scheduling a meeting, the team should just do it. If they'd Slack the product owner first, the PM should ask.

### Gate Approval

Each phase has a **Gate Approved By** field that determines who signs off before the next phase begins:

| Approver     | Meaning |
| ------------ | ------- |
| **🧑 Human** | You (the product owner) must personally review and approve. The agent must stop and wait for your explicit sign-off. |
| **🤖 Agent (PM)** | A project manager agent reviews the gate checklist, verifies all items are met, and may approve autonomously. It should still flag concerns or ambiguities to the human rather than making judgment calls. |

> **Rule**: Even when a gate is agent-approved, the human can always override or request a re-review. Agent approval is a delegation of routine verification, not a delegation of decision-making.

### Phase Summary

| Phase | Name                          | Gate Approved By  |
| ----- | ----------------------------- | ----------------- |
| 0     | Project Initialization        | 🤖 Agent (PM)    |
| 1     | Product Specification         | 🧑 Human         |
| 2     | Architecture & Technical Design | 🧑 Human       |
| 3     | Task Breakdown & Planning     | 🤖 Agent (PM)    |
| 4     | Development                   | 🤖 Agent (PM) *  |
| 5     | Quality & Security Hardening  | 🧑 Human         |
| 6     | Deployment & Launch Prep      | 🧑 Human         |
| 7     | Iteration & Backlog           | Ongoing — no gate |

> \* Phase 4 individual milestone checkpoints still require human sign-off. The phase gate verifies all milestones are complete.

---

## Agent Team Structure

This playbook is executed by a **team of specialized agents** running within a single Claude Code instance. The human communicates **only with the PM agent**. The PM delegates work, coordinates the team, and escalates to the human when needed.

### Roles

| Agent | Role | Responsibilities |
|-------|------|-----------------|
| **🎯 PM (Project Manager)** | Orchestrator & human interface | Owns the spec, requirements, and priorities. Delegates tasks to other agents. Reviews all work. Manages gates and milestones. Resolves minor conflicts. Escalates major decisions to the human. The PM is the **only agent that speaks to the human**. |
| **🏗️ Architect** | Technical design authority | Owns tech stack, architecture, data model, API design. Reviews all code for architectural consistency. Proposes MCP servers and skills. Approves or rejects technical approaches before code is written. |
| **💻 Developer** | Implementation | Writes application code, implements features, fixes bugs. Works within the architecture defined by the Architect. Writes unit and integration tests for all code. Follows the golden rules. |
| **🧪 QA (Quality Assurance)** | Testing & quality | Writes and maintains E2E tests (Playwright). Performs exploratory testing. Reviews test coverage. Identifies bugs, edge cases, and UX issues. Validates that acceptance criteria are met before an issue moves to Done. |
| **🔒 Security** | Security & compliance | Reviews all code for vulnerabilities. Owns the security audit (Phase 5). Reviews auth flows, input validation, API security, and AI guardrails. Flags security issues as blocking. |
| **🚀 DevOps** | Infrastructure & deployment | Owns CI/CD pipeline, deployment scripts, environment configuration, monitoring, and health checks. Manages production domain setup and database operations. |

### Communication Protocol

All agents operate within the same Claude Code instance. They coordinate through structured communication:

1. **PM delegates work** — The PM assigns tasks to specific agents by role. Each task includes context, acceptance criteria, and the target branch.
2. **Agents report back to PM** — When work is complete, the agent reports results to the PM, who decides the next step.
3. **Cross-agent reviews** — Before merging, work is reviewed by the relevant agent(s):
   - All code → reviewed by **Architect** (architecture consistency) and **Security** (vulnerabilities).
   - All features → validated by **QA** (acceptance criteria, test coverage).
   - All infrastructure changes → reviewed by **Security** (configuration, secrets).
4. **Agents do not talk to the human directly.** All human communication goes through the PM. If an agent needs human input, they tell the PM, who escalates.

### Branch Strategy

Each agent works in branches to keep work isolated and reviewable:

| Branch | Purpose | Created By | Merges Into |
|--------|---------|-----------|-------------|
| `main` | Production-ready code | DevOps (via deploy) | — |
| `develop` | Integration branch | PM | `main` (at milestones) |
| `feat/<issue>` | Feature implementation | Developer | `develop` |
| `fix/<issue>` | Bug fixes | Developer | `develop` |
| `security/<issue>` | Security fixes | Security | `develop` |
| `infra/<issue>` | Infrastructure changes | DevOps | `develop` |
| `test/<issue>` | Test additions/fixes | QA | `develop` |

**Merge rules:**
- No branch merges into `develop` without PM approval.
- No branch merges without passing all tests.
- Security-labeled issues require **Security agent sign-off** before merge.
- `develop` merges into `main` only at milestone completions with human sign-off.

### Conflict Resolution

Conflicts between agents are inevitable. Here's the resolution hierarchy:

**Minor conflicts (PM resolves autonomously):**
- Code style or naming disagreements.
- Implementation approach when both options satisfy requirements.
- Test strategy details (which scenarios to cover first).
- Task prioritization within a milestone.

**Major conflicts (Escalate to human):**
- Scope changes or requirement reinterpretation.
- Tech stack changes or new dependency additions.
- Timeline-impacting disagreements.
- Architectural pivots.
- Any conflict the PM is uncertain about.

**Security overrides (Security wins by default):**
- When Security and Developer disagree on an implementation, **Security wins** unless the human explicitly overrides.
- Security can flag any issue as **blocking** — it cannot be closed or deprioritized without human approval.
- Security can request re-implementation of a feature if it identifies a vulnerability that cannot be patched.
- The only person who can overrule Security is the human.

> **Escalation format** (PM to human):
>
> "**Conflict**: [brief description]
> **Agent A** (Developer) says: [position + reasoning]
> **Agent B** (Security) says: [position + reasoning]
> **My recommendation**: [PM's suggested resolution]
> **I need your decision to proceed.**"

### Phase Ownership

Each phase has a **lead agent** who drives the work, supported by others:

| Phase | Lead | Supporting Agents |
|-------|------|-------------------|
| 0 — Project Init | PM | DevOps |
| 1 — Product Spec | PM | Architect (feasibility check) |
| 2 — Architecture | Architect | PM (requirements alignment), Security (threat model), DevOps (infra feasibility) |
| 3 — Task Breakdown | PM | All agents review their domain's issues |
| 4 — Development | Developer | QA (continuous testing), Architect (code review), Security (security review), DevOps (CI/CD) |
| 5 — Hardening | Security (lead), QA (co-lead) | Developer (fixes), DevOps (infra hardening) |
| 6 — Deployment | DevOps | Security (production security), QA (smoke tests), PM (demo script) |
| 7 — Iteration | PM | All agents contribute to retrospective and backlog |

### How This Works in Practice

Since all agents run in a **single Claude Code instance**, the PM mentally adopts each role when performing that role's work. The structure ensures:

1. **Separation of concerns** — The agent doesn't skip security review because it's eager to ship. Each role has a checklist to complete.
2. **Adversarial review** — Security actively looks for problems in Developer's code. QA tries to break things. This produces better outcomes than a single perspective.
3. **Clear accountability** — When something goes wrong, the playbook makes it clear which role should have caught it.
4. **Structured escalation** — The PM knows exactly when to involve the human vs. resolve independently.

The PM should think of itself as managing a real team. When reviewing code as Security, it should be skeptical and thorough — not rubber-stamp its own Developer work.

### Context Management (Preventing Context Rot)

> **Context rot** is the progressive degradation of AI quality as the context window fills up. By task 50, the agent forgets decisions from task 1, generates inconsistent code, and loses track of the architecture. This is the #1 reliability risk in long-running agent sessions.

This playbook combats context rot using a **fresh sub-agent model** inspired by the GSD framework:

**Principle: The orchestrator stays light. Workers get fresh context.**

```
┌─────────────────────────────────────────────────────────────┐
│  PM (Orchestrator)                                          │
│  - Stays at 30-40% context utilization                      │
│  - Holds: project state, current milestone, task queue      │
│  - Does NOT hold: implementation details, full code files   │
│                                                             │
│  For each task, PM spawns a fresh sub-agent:                │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  Sub-Agent (Developer/QA/Security/etc.)                │ │
│  │  - Gets a clean, full context window                   │ │
│  │  - Receives: task instructions, relevant files,        │ │
│  │    CLAUDE.md, architecture excerpts                    │ │
│  │  - Does the work, commits, reports back                │ │
│  │  - Context is discarded after task completion          │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                             │
│  Task 50 gets the same quality as Task 1.                   │
└─────────────────────────────────────────────────────────────┘
```

**Rules for context management:**
1. **PM never writes code directly.** It delegates to sub-agents who have fresh context for each task.
2. **Each sub-agent receives only what it needs** — the task description, relevant source files, CLAUDE.md, and the relevant section of ARCHITECTURE.md. Not the entire project history.
3. **Sub-agents report results back to PM** in a structured format: what was done, what files changed, what tests were added/modified, any concerns.
4. **PM maintains a lightweight state file** (`.planning/STATE.md`) that tracks: current milestone, completed tasks, in-progress tasks, blocked tasks, and key decisions. This is the orchestrator's memory — it persists across sessions.
5. **If the PM's context gets heavy** (above ~60%), it should start a new session, re-read CLAUDE.md and `.planning/STATE.md`, and continue. No work is lost because state is in files, not in context.
6. **Agents maintain a shared learnings file** (`.planning/LEARNINGS.md`). After each task, the executing agent appends any useful discoveries: patterns found in the codebase, gotchas encountered, conventions established, or workarounds applied. This file is included in every sub-agent's context, so the team gets smarter over time — future iterations benefit from past mistakes without needing to rediscover them.

```markdown
## Example: .planning/LEARNINGS.md entries

### 2026-02-13 — Developer
- The ORM doesn't support upserts natively. Use raw SQL with ON CONFLICT for the sync endpoint.
- Tailwind's `ring` utility conflicts with the shadcn/ui focus styles. Use `outline` instead.

### 2026-02-13 — Security
- The AI service layer was passing raw user input into the system prompt. Added sanitization in `ai/sanitize.ts`. All AI endpoints must use this.

### 2026-02-14 — QA
- Playwright tests for the chatbot need a 2s wait after sending a message — the AI response streams in and the DOM updates asynchronously.

### 2026-02-14 — DevOps
- The health check endpoint must NOT call the AI API — it was causing $3/day in unnecessary token spend. Use a cached status flag instead.
```

### Execution Model: Waves & Parallelism

Instead of executing tasks purely sequentially, the PM organizes work into **waves** within each milestone:

```
Milestone v0.2 — Core Feature + AI
│
├── Wave 1 (independent, can run in parallel):
│   ├── Task: Set up AI service layer scaffold
│   ├── Task: Create database migration for core entities
│   └── Task: Build API endpoint stubs (no business logic yet)
│
├── Wave 2 (depends on Wave 1):
│   ├── Task: Implement core AI-powered workflow
│   └── Task: Implement CRUD operations for core entities
│
├── Wave 3 (depends on Wave 2):
│   ├── Task: Wire frontend to API
│   └── Task: Add error handling and fallbacks for AI calls
│
└── Wave 4 (verification):
    ├── Task: QA writes E2E tests for core workflow
    └── Task: Security reviews AI integration
```

**Wave rules:**
- Within a wave, tasks are **independent** — they can run in parallel (or at minimum, in any order without conflicts).
- A wave only starts after the previous wave is **fully complete and verified**.
- The PM is responsible for analyzing task dependencies and organizing waves.
- Wave organization is documented in `.planning/STATE.md` so it survives session resets.
- The final wave of each milestone is always **verification** (QA + Security review).

### Goal-Backward Verification

Traditional verification asks: *"Did we complete all the tasks?"* This playbook uses **goal-backward verification**, which asks: *"What must be TRUE for this milestone to be considered working?"*

The difference is critical. Completing tasks doesn't guarantee the product works. Testing observable outcomes does.

**How it works:**

1. Before starting a milestone, the PM defines **truth conditions** — observable behaviors that must be true when the milestone is complete:

```markdown
## Milestone v0.2 — Truth Conditions

- [ ] A new user can register, verify email, and log in.
- [ ] A logged-in user can trigger the core AI workflow and receive a valid result.
- [ ] If the AI API is down, the user sees a graceful fallback message (not a crash).
- [ ] The AI service layer logs the API call with token count and latency.
- [ ] An unauthorized user cannot access the AI endpoint (returns 401).
- [ ] All truth conditions can be verified by running `npm test` and the Playwright E2E suite.
```

2. Truth conditions are defined **before development starts** — they're part of the milestone planning in Phase 3.
3. At the milestone checkpoint, **QA verifies each truth condition** independently — not by checking if tasks are done, but by testing if the conditions hold.
4. If a truth condition fails, it doesn't matter that "all tasks are done" — the milestone is **not complete** until the condition passes.
5. Truth conditions are stored in `.planning/STATE.md` alongside the wave plan.

> **This is the key mindset shift**: tasks are how you get there; truth conditions are how you know you've arrived.

---

## Phase 0: Project Initialization

### Inputs Required

Provide the following before anything else:

| Input            | Description                                          | Example                              |
| ---------------- | ---------------------------------------------------- | ------------------------------------ |
| **Project Name** | Short, memorable name                                | `MealPlanr`                          |
| **Project Idea** | 1–3 sentence description of what the product does    | "A meal planning app that generates weekly grocery lists based on dietary preferences." |
| **GitHub Repo**  | Repository URL (existing or to be created)           | `github.com/user/mealplanr`          |
| **GitHub Project**| GitHub Projects board for task tracking              | `MealPlanr Tracker`                  |
| **Target Users** | Who is this for? (even a rough guess helps)          | "Busy professionals who want to eat healthier" |
| **Production Domain** | The domain where the app will be deployed       | `mealplanr.com` or `app.mealplanr.com` |
| **AI API Key(s)** | OpenAI (or other LLM provider) API key for AI features | `sk-...` (stored as env secret, never committed) |

### Service Keys & External Dependencies Protocol

The AI API key is provided upfront. However, as the architecture takes shape, the agent may identify additional third-party services that require API keys (e.g., Resend for email, Stripe for payments, Twilio for SMS, Cloudinary for images, etc.).

**The agent must follow this protocol for every additional service:**

1. **Identify the need.** During architecture or development, the agent determines a third-party service is needed.
2. **Request with justification.** The agent asks the human for the key, explaining:
   - What service is needed and why.
   - What feature depends on it.
   - Whether there's a free-tier or alternative approach if the key is denied.
3. **Wait for a response.** The human will either:
   - ✅ **Provide the key** — Agent adds it to `.env.example` (placeholder only, never the real value) and configures the integration.
   - ❌ **Deny the request** — Agent must find an alternative approach or document the feature as out of scope. The agent must **not** build the feature assuming the key will come later.
4. **Never assume a service is available.** The agent does not install SDKs, write integration code, or add environment variables for a service until the human has confirmed and provided the key.
5. **Track in `.env.example`.** Every approved key gets a placeholder entry with a comment explaining its purpose.

> **Example exchange:**
> 
> Agent: "The email verification flow requires a transactional email service. I recommend Resend — it has a generous free tier (100 emails/day) and a simple API. Can you provide a Resend API key? If not, I can implement a magic-link flow using the app's own SMTP or skip email verification for MVP."
> 
> Human: "Here's the key: re_..." or "Skip it for MVP, use console logging for verification codes."

### Actions

1. Agent creates (or confirms) the GitHub repo.
2. Agent creates (or confirms) the GitHub Project board with the following columns: `Backlog`, `To Do`, `In Progress`, `In Review`, `Done`.
3. Agent creates the initial folder structure:

```
/
├── .planning/
│   ├── STATE.md                # Orchestrator state (milestones, waves, truth conditions)
│   └── LEARNINGS.md            # Accumulated team knowledge across iterations
├── docs/
│   ├── PRODUCT_SPEC.md
│   ├── ARCHITECTURE.md
│   └── DEMO.md
├── scripts/
│   ├── deploy.sh              # Production deployment script
│   ├── deploy-rollback.sh     # Rollback to previous version
│   └── seed.sh                # Database seed script
├── skills/                    # Downloaded skill files (added in Phase 2)
├── CLAUDE.md
├── README.md
├── .env.example
└── ... (source code added later)
```

### Gate — `🤖 Agent (PM)`

- [ ] Repo exists and is accessible.
- [ ] Project board exists with correct columns.
- [ ] Folder structure is committed.
- [ ] Agent confirms all inputs are understood and asks any clarifying questions.

---

## Phase 1: Product Specification

### Goal

Produce a comprehensive `docs/PRODUCT_SPEC.md` that fully describes *what* the product does (not *how* — that comes later).

### Step 1.1 — Draft the Spec

Create `docs/PRODUCT_SPEC.md` with the following sections:

1. **Product Overview** — What is this product? What problem does it solve? (2–3 paragraphs)
2. **Target Users** — User personas with goals and pain points.
3. **User Stories** — Organized by persona. Use the format: *"As a [persona], I want [action] so that [benefit]."*
4. **User Profile & Data Model**
   - What information do we need from each user to serve them well?
   - Include profile creation, update, and deletion flows.
   - Include account deletion by the user themselves (GDPR/privacy compliance).
   - Consider internationalization — make the app global-ready (timezone, locale, currency, language).
5. **Core Workflows** — Step-by-step description of the 3–5 most important user journeys. Describe each screen/state the user sees.
6. **AI Integration** — This product is AI-powered. Specify AI features across three tiers:

   **Tier 1: Core Business Logic (AI-native)**
   - Identify which core workflows should be powered by AI (e.g., generating plans, analyzing data, making recommendations).
   - For each AI-powered workflow, define: the input, the expected output, fallback behavior if the AI call fails.
   - These are not optional — they are the product's value proposition.

   **Tier 2: Smart Suggestions**
   - Context-aware suggestions surfaced proactively to users (e.g., "Based on your history, you might want to...").
   - Define where suggestions appear in the UI and what triggers them.
   - Suggestions must be non-blocking — the user can dismiss or ignore them.

   **Tier 3: In-App Chatbot**
   - A conversational assistant embedded in the app.
   - **Scoped strictly to the app's domain.** The chatbot must refuse to answer off-topic questions (e.g., "write me a poem", "what's the weather") with a polite redirect.
   - **Memory**: The chatbot retains conversation history per user session and can reference the user's data (profile, history, preferences) for personalized answers.
   - **Guardrails**: Define what the chatbot can and cannot do:
     - ✅ Answer questions about the app, the user's data, and the product domain.
     - ✅ Help users complete workflows ("help me set up my profile").
     - ✅ Provide explanations of AI-generated outputs ("why did you suggest X?").
     - ❌ General knowledge, off-topic conversation, anything outside the app's domain.
     - ❌ Execute destructive actions without user confirmation.
   - **Conversation starters**: Pre-defined prompts to guide users (e.g., "What can you help me with?", "Explain my latest report").

7. **Admin Panel**
   - Admin user role with elevated privileges.
   - User management (view, suspend, delete users).
   - Product usage monitoring and basic analytics dashboard.
   - Admin audit log (who did what, when).
   - **AI usage dashboard**: Token consumption, cost tracking, per-user AI usage, error rates for AI calls.
   - **Chatbot monitoring**: View flagged conversations, review off-topic attempt logs.
8. **Out of Scope (for MVP)** — Explicitly list what this version will NOT do.

### Step 1.2 — First Review Pass (Critical Feedback)

- Agent analyzes the spec and provides **critical feedback**: gaps, contradictions, missing edge cases, unclear stories.
- Human reviews feedback, makes decisions.
- Agent revises the spec.
- **Repeat until both sides are satisfied.** Aim for 2–3 iterations.

### Step 1.3 — Requirements Extraction

Once the spec is stable, agent produces two additional sections appended to the spec:

**Functional Requirements (FR)**
- Numbered list (FR-001, FR-002, ...).
- Each must be testable and unambiguous.
- Derived directly from user stories and workflows.

**Non-Functional Requirements (NFR)**
- Performance targets (e.g., page load < 2s, API response < 500ms).
- Scalability expectations (concurrent users, data volume).
- Availability target (e.g., 99.9% uptime).
- Accessibility (WCAG 2.1 AA minimum).
- Browser / device support matrix.
- Internationalization and localization requirements.

### Step 1.4 — Security Requirements

Agent adds a **Security** section to the spec covering:

- **Authentication**: Password strength rules, hashing algorithm (bcrypt/argon2), rotation policy.
- **Registration controls**: Block automated/bot registrations (CAPTCHA, email verification, rate limiting).
- **Authorization**: Role-based access control (RBAC) — at minimum: `user`, `admin`.
- **Session management**: Token expiry, refresh strategy, concurrent session limits.
- **Data protection**: Encryption at rest and in transit, PII handling, data retention policy.
- **Input validation**: Sanitization strategy for all user inputs.
- **Rate limiting**: API rate limits per endpoint category.
- **Audit logging**: What events are logged, retention period.
- **AI API Security**:
  - API keys stored as environment secrets — never in source code, logs, or client-side code.
  - All AI calls routed through the backend (never expose the AI API key to the frontend).
  - Per-user rate limits on AI features to prevent abuse and cost overruns.
  - Input sanitization before sending user content to the AI API (prevent prompt injection).
  - AI response validation — never trust raw AI output; validate/sanitize before displaying or acting on it.
  - Cost controls: Set monthly spend limits / alerts on the AI API account.
  - Chatbot guardrails enforced server-side (not just via system prompt — validate responses before returning to user).

### Gate — `🧑 Human`

- [ ] `PRODUCT_SPEC.md` is complete with all sections above.
- [ ] Human has reviewed and approved the spec.
- [ ] Requirements are numbered and traceable to user stories.
- [ ] Security section is reviewed and approved.

---

## Phase 2: Architecture & Technical Design

### Goal

Produce `CLAUDE.md`, `docs/ARCHITECTURE.md`, and `README.md` that define *how* the product will be built.

### Step 2.1 — Tech Stack Decision

Agent proposes a tech stack with justifications. Human approves or adjusts. Document in `CLAUDE.md`.

> ⚠️ **If any tech stack choice requires a third-party API key not already provided**, the agent must follow the **Service Keys & External Dependencies Protocol** from Phase 0 before proceeding. Do not assume a service is available.

Consider and document decisions for:

| Layer             | Decision Needed                                      |
| ----------------- | ---------------------------------------------------- |
| Frontend          | Framework (React, Next.js, Vue, etc.), styling approach |
| Backend           | Language/framework (Node/Express, Python/FastAPI, etc.) |
| Database          | SQL vs NoSQL, specific engine (Postgres, MongoDB, etc.) |
| Auth              | Strategy (JWT, sessions, OAuth provider, etc.)       |
| **AI Provider**   | OpenAI (GPT-4o, etc.) — model selection, SDK version |
| **External Services** | Email (Resend, SendGrid), payments (Stripe), storage (S3), etc. — **request keys per protocol** |
| File Storage      | If needed (S3, Cloudinary, local, etc.)              |
| Hosting           | Where will this run? (Vercel, AWS, Railway, etc.)    |
| **Production Domain** | Domain name, DNS provider, SSL certificate strategy |
| CI/CD             | GitHub Actions, etc.                                 |
| Monitoring        | Error tracking, logging (Sentry, LogRocket, etc.)    |

### Step 2.2 — Architecture Document

Create `docs/ARCHITECTURE.md` with:

1. **System Overview Diagram** — High-level boxes-and-arrows (describe in Mermaid or ASCII).
2. **Component Breakdown** — Frontend, backend, database, external services.
3. **Data Model / Schema** — Every entity, its fields, types, and relationships. This is critical — the agent must produce a complete ER diagram or table-based schema before writing any code.
4. **API Design** — List every API endpoint:
   - Method, path, request body, response shape, auth requirement.
   - Group by resource (e.g., `/api/users`, `/api/meals`).
   - Include error response formats.
5. **Auth Flow** — Detailed sequence: registration → email verification → login → token refresh → logout.
6. **Data Flow Diagrams** — For the top 3 core workflows from the spec.
7. **Error Handling Strategy** — How errors are caught, logged, and surfaced to users. Include:
   - Global error boundary (frontend).
   - Centralized error handler (backend).
   - Structured error response format.
   - Logging levels and what goes where.
8. **Environment & Configuration** — Document all environments and their config:
   - `development`, `staging`, `production`.
   - Environment variable naming convention and list.
   - Secrets management approach.
   - `.env.example` template.
9. **Folder Structure** — Proposed project directory layout with explanations.
10. **AI Architecture** — This is a critical section. Document:
    - **AI Service Layer**: A dedicated module/service that wraps all AI API calls. No part of the codebase should call OpenAI directly — everything goes through this layer. This enables: centralized error handling, token tracking, easy model swapping, and mock/stub testing.
    - **Model Selection**: Which model for which task (e.g., GPT-4o for business logic, GPT-4o-mini for suggestions/chatbot to manage costs).
    - **Prompt Management**: How prompts are stored, versioned, and maintained. Prompts should be treated as code — stored in files (not inline strings), version-controlled, and reviewed.
    - **Chatbot Architecture**:
      - System prompt design (enforce app-only scope, define personality, set boundaries).
      - Conversation memory: Storage strategy (DB table with user_id, session_id, messages[]), max context window management (truncation/summarization strategy when history gets long).
      - User context injection: How the user's profile/data is included in the chatbot's context for personalized responses.
      - Topic guardrail implementation: Server-side classification of user messages — reject off-topic requests before they reach the AI API (saves cost and enforces scope).
    - **Fallback Strategy**: What happens when the AI API is down, slow, or returns an error? Every AI-powered feature must have a defined fallback (graceful degradation, cached response, manual alternative, or clear error message).
    - **Token & Cost Tracking**: Schema for logging every AI API call (user_id, endpoint, model, input_tokens, output_tokens, cost, latency, timestamp). This feeds the admin dashboard.
11. **Production Deployment Architecture** — Document:
    - Production domain and DNS configuration.
    - SSL/TLS setup (Let's Encrypt, Cloudflare, or provider-managed).
    - Production deployment script (`scripts/deploy.sh`) — what it does step-by-step.
    - Rollback script (`scripts/deploy-rollback.sh`) — how to revert to the previous version.
    - Zero-downtime deployment strategy (blue-green, rolling, etc.).
    - Health check and smoke test endpoints.
    - Backup strategy for the database.

### Step 2.3 — Tooling Augmentation (MCP Servers & Skills)

Now that the architecture is defined, the **Architect** (with input from all agents) should take time to think about what tools would make development faster and the product better. This step has two parts:

**Part A: MCP Servers**

The Architect reviews the architecture and identifies MCP servers that could augment development or the product itself. Each agent may suggest tools for their domain:

| Category | Purpose | Examples | Suggested By |
|----------|---------|---------|-------------|
| **Development MCP** | Helps agents build faster | Postgres MCP (direct DB interaction), GitHub MCP (issue management) | Architect, Developer |
| **Testing MCP** | Helps QA validate faster | Browser testing tools, API testing tools | QA |
| **Security MCP** | Helps Security audit better | Vulnerability scanners, dependency auditors | Security |
| **Infrastructure MCP** | Helps DevOps manage environments | Cloud provider tools, container management | DevOps |
| **Product MCP** | Powers features in the running product | Browser automation, data connectors | Architect, PM |

**Protocol:**
1. Each agent proposes MCP servers relevant to their role.
2. Architect consolidates into a prioritized list. For each: what it does, why it helps, and fallback without it.
3. PM presents the list to the human for approval.
4. Approved → DevOps installs and configures the MCP server.
5. Denied → Architect documents the fallback approach and the team proceeds without it.

> **Example:**
>
> PM to Human: "The team recommends the following MCP servers:
> 1. **Postgres MCP** (Architect) — Direct DB queries during development. Fallback: raw SQL scripts and CLI.
> 2. **GitHub MCP** (PM) — Programmatic issue/PR management. Fallback: manual management.
> 3. **Resend MCP** (Developer) — Streamline email template testing. Fallback: test via API directly.
>
> Which of these should we set up?"

**Part B: Skills Acquisition**

The team identifies skill files (SKILL.md or equivalent) available online that would improve output quality for this specific project. Skills are specialized instruction sets for tasks like generating specific file types, following framework patterns, or applying design systems. Any agent can propose skills relevant to their domain.

**Protocol:**
1. Each agent reviews their domain and identifies skills that would improve results (e.g., Developer: "Next.js App Router patterns", QA: "Playwright E2E best practices", Developer: "OpenAI streaming implementation").
2. Architect consolidates proposals. For each: source URL, what it covers, and why it's relevant.
3. PM presents the list to the human for approval.
4. Approved → Agent downloads and stores the skill file in a `skills/` directory in the repo for ongoing reference.
5. Denied → Team proceeds with built-in knowledge. Architect documents any areas where output quality may be lower.

> **Example:**
>
> PM to Human: "The team would like to download these skill files:
> 1. **Tailwind + shadcn/ui patterns** (Developer) — Consistent, polished UI components. Source: [URL]
> 2. **OpenAI function calling patterns** (Developer) — Best practices for structured AI outputs. Source: [URL]
> 3. **Playwright advanced patterns** (QA) — Complex E2E test scenarios. Source: [URL]
>
> Should we download these?"

**Important rules:**
- No agent may download or install anything without PM approval and human confirmation.
- Skills are stored in the repo (`skills/`) so they're versioned and visible.
- Skills are shared across the team — any agent can reference any approved skill.
- MCP servers that require API keys follow the **Service Keys Protocol** from Phase 0.
- The team should revisit this step at any milestone checkpoint if any agent identifies new tools that would help.

### Step 2.4 — CLAUDE.md (Agent Instructions File)

This is the file the agent reads every time it starts a session. It must be concise and authoritative.

```markdown
# CLAUDE.md

## Project Overview
See [docs/PRODUCT_SPEC.md](docs/PRODUCT_SPEC.md) for full product specification.
[1-2 sentence summary here]

## Team Structure
You are a team of specialized agents operating within a single Claude Code instance.
See the **Agent Team Structure** section in APP_BUILDER_PLAYBOOK.md for full details.

- **🎯 PM**: Orchestrator. Only agent that talks to the human. Delegates, reviews, resolves minor conflicts.
- **🏗️ Architect**: Tech design authority. Reviews all code for architectural consistency.
- **💻 Developer**: Writes code and tests. Works within the Architect's design.
- **🧪 QA**: Writes E2E tests, validates acceptance criteria, finds bugs.
- **🔒 Security**: Reviews all code for vulnerabilities. **Security overrides Developer in disputes.**
- **🚀 DevOps**: CI/CD, deployment, infrastructure, monitoring.

When performing work, adopt the mindset of the responsible agent. When reviewing as Security, be skeptical of your own Developer work.

## Tech Stack
[From Step 2.1]

## Architecture
See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for full architecture.

## Development Golden Rules (Non-Negotiable)
1. **Test everything.** Write unit tests for every function/module. Integration tests for every API endpoint. E2E tests with Playwright for every critical user flow.
2. **Run all tests after every change.** No code is committed if tests fail.
3. **No skipping tests.** Never use `.skip`, `xit`, or comment out tests to make them pass.
4. **Update documentation.** If you change behavior, update the relevant docs.
5. **Never delete or modify existing tests** without explicit human approval.
6. **Follow the API contract.** Do not deviate from the documented API design without consultation.
7. **Handle errors explicitly.** No silent catches. Every error must be logged and surfaced appropriately.
8. **No hardcoded secrets or config values.** Everything goes through environment variables.
9. **Commit often with clear messages.** Use conventional commits (feat:, fix:, docs:, test:, refactor:).
10. **Act like a senior team.** Make routine decisions autonomously — implementation details, library choices, refactoring approaches, test strategies. Only escalate to the human for product decisions, scope changes, pivots, new services, or unresolvable conflicts. When in doubt about whether to ask: if a senior engineer would just do it, do it.
11. **All AI calls go through the AI service layer.** Never call OpenAI (or any AI provider) directly from routes, controllers, or frontend code.
12. **Every AI feature has a fallback.** If the AI API fails, the user sees a graceful degradation — never a blank screen or raw error.
13. **Never expose AI API keys to the frontend.** All AI calls are server-side only.
14. **Log every AI API call.** Track user, model, tokens, cost, and latency for every call.
15. **Chatbot stays on topic.** Enforce topic guardrails server-side, not just via system prompt.
16. **No service without a key.** Never install SDKs, write integration code, or assume a third-party service is available until the human has provided the API key. Follow the Service Keys Protocol.
17. **Leverage MCP servers and skills.** Use approved MCP servers and downloaded skills to produce the best possible output. Revisit tooling needs at each milestone checkpoint — if a new MCP server or skill would help, propose it.
18. **Respect the team hierarchy.** Security overrides Developer. PM resolves minor conflicts. Major conflicts go to the human. No agent bypasses the review process.
19. **Fresh context for every task.** PM delegates tasks to sub-agents with clean context. Never accumulate implementation details in the orchestrator. If PM context exceeds 60%, start a new session and re-read CLAUDE.md + `.planning/STATE.md` + `.planning/LEARNINGS.md`.
20. **Atomic tasks only.** Every task should touch ≤ 3 files, fit in ≤ 50% of context, and be testable in isolation. If it's too big, split it.
21. **Truth conditions over task completion.** A milestone is done when its truth conditions pass, not when its tasks are checked off. Always verify observable outcomes.
22. **Log learnings.** After every task, append useful discoveries to `.planning/LEARNINGS.md` — patterns, gotchas, conventions, workarounds. The team's future selves will thank you.

## Testing
- **Unit tests**: [framework, e.g., Jest / pytest]
- **Integration tests**: [framework]
- **E2E tests**: Playwright
- **AI service tests**: Mock the AI API — test prompt construction, response parsing, fallbacks, and guardrails without making real API calls.
- **Coverage target**: 80% minimum, 90%+ for critical paths
- **Test data**: Use seed scripts, never test against production data.

## Deployment
- **Production domain**: [domain from inputs]
- **Hosting**: [From Step 2.1]
- **Deploy**: `./scripts/deploy.sh` — runs tests, builds, deploys, runs smoke tests.
- **Rollback**: `./scripts/deploy-rollback.sh` — reverts to the previous deployment.
- **CI/CD**: [pipeline summary]

## Repository
- **Repo**: [GitHub URL]
- **Project Board**: [GitHub Project URL]
- **Branch strategy**: `main` (production), `develop` (integration), feature branches (`feat/xyz`).
```

### Step 2.5 — README.md

Create `README.md` with:

1. **What this product is** — 1–2 paragraphs.
2. **Who it's for** — Target users.
3. **High-level architecture** — Simple diagram or bullet summary.
4. **Prerequisites** — Required tools, versions (Node 20+, Python 3.11+, etc.).
5. **How to run locally** — Step-by-step with copy-paste commands.
6. **How to run tests** — Commands for unit, integration, and E2E.
7. **How to deploy** — High-level overview.
8. **Environment variables** — Reference to `.env.example`.
9. **Links to deeper docs** — Spec, architecture, demo script.

### Gate — `🧑 Human`

- [ ] `CLAUDE.md` is complete and reviewed.
- [ ] `docs/ARCHITECTURE.md` is complete with data model, API design, and all sections.
- [ ] `README.md` is complete.
- [ ] Human has approved tech stack, data model, and API design.
- [ ] MCP servers have been proposed, approved/denied, and configured (or fallbacks documented).
- [ ] Skills have been proposed, approved/denied, and downloaded (or gaps documented).
- [ ] All docs are consistent with each other and with the spec.

---

## Phase 3: Task Breakdown & Planning

### Goal

Convert all requirements into trackable GitHub issues with milestones, so development is structured and incremental.

### Step 3.1 — Define Milestones & Truth Conditions

Create version milestones that give the agent small, testable targets:

| Milestone | Scope | Examples |
|-----------|-------|---------|
| **v0.1 — Foundation** | Project setup, CI/CD, database, auth | Repo scaffolding, DB migrations, login/register, basic tests |
| **v0.2 — Core Feature + AI** | The #1 user workflow end-to-end, powered by AI | AI service layer, core AI-powered feature working, prompt management, fallback handling |
| **v0.3 — Smart Features** | Suggestions, chatbot, remaining user stories | AI suggestions engine, chatbot with memory + guardrails, profile management |
| **v0.4 — Admin & Analytics** | Admin panel, AI usage tracking, monitoring | User management, AI usage dashboard, chatbot monitoring, cost tracking |
| **v0.5 — Polish & Harden** | UI polish, error handling, security hardening | Edge cases, loading states, error pages, input validation, AI security audit |
| **v1.0 — Launch Ready** | Production deployment to domain, monitoring, demo | Deploy scripts, health checks, seed data, demo script, cost alerts |

**For each milestone, define truth conditions** — observable outcomes that must be verifiable when the milestone is complete. These are not tasks; they are the *proof* that the milestone works.

```markdown
## Example: v0.1 — Foundation — Truth Conditions

- [ ] Running `npm run dev` starts the app without errors.
- [ ] A new user can register with email and password.
- [ ] Registration is blocked without email verification.
- [ ] A verified user can log in and receive a valid session token.
- [ ] An invalid password returns a 401, not a 500.
- [ ] The CI pipeline runs on push to `develop` and reports pass/fail.
- [ ] All truth conditions are covered by automated tests.
```

Truth conditions are stored in `.planning/STATE.md` and are the **primary success criteria** at each milestone checkpoint.

### Step 3.2 — Create GitHub Issues (Atomic Task Sizing)

Agent logs **every** requirement as a GitHub issue with:

- **Title**: Clear, action-oriented (e.g., "Implement user registration with email verification").
- **Labels**: `feature`, `bug`, `security`, `testing`, `documentation`, `infrastructure`, `ai`.
- **Milestone**: Assigned to the correct version milestone.
- **Description**: Acceptance criteria — what "done" looks like. Reference the FR/NFR number.
- **Dependencies**: Note if an issue blocks or is blocked by another.

**Atomic task sizing rules (critical for context management):**

Each issue must be small enough for a **fresh sub-agent to complete in a single session** without context degradation. Apply these constraints:

| Rule | Guideline |
|------|-----------|
| **Max scope** | Each task should touch **≤ 3 files** in its core change (tests and docs don't count toward this limit). |
| **Context budget** | The task description + relevant source files + CLAUDE.md should fit in **≤ 50% of the context window**. If it doesn't, split the task. |
| **Single responsibility** | Each task does ONE thing: add an endpoint, write a migration, build a component. Never "build the whole auth system" as one task. |
| **Testable in isolation** | The task must be verifiable with a test that can run independently. If you can't write a test for it, the task is too vague. |
| **Time estimate** | If a task would take a human developer more than ~2 hours, it should be split. |

> **Anti-pattern**: "Implement user authentication" → Too big.
> **Correct**: Split into: "Create users table migration" → "Add password hashing utility" → "Build POST /api/auth/register endpoint" → "Build POST /api/auth/login endpoint" → "Add JWT token generation and validation" → "Write auth middleware" → "Write auth endpoint integration tests"

### Step 3.3 — Wave Planning & Prioritization

For each milestone, the PM organizes issues into **waves** based on dependencies:

1. **Analyze dependencies** — Which tasks are independent? Which depend on others?
2. **Group into waves** — Independent tasks go in the same wave. Dependent tasks go in later waves.
3. **Always end with a verification wave** — The final wave of each milestone is QA + Security review.
4. **Document the wave plan** in `.planning/STATE.md`.

```markdown
## Example: v0.1 — Foundation — Wave Plan

### Wave 1 (independent — can run in any order):
- [ ] #1 — Project scaffolding and folder structure
- [ ] #2 — Database setup and connection config
- [ ] #3 — CI/CD pipeline setup (GitHub Actions)

### Wave 2 (depends on Wave 1):
- [ ] #4 — Create users table migration
- [ ] #5 — Add password hashing utility
- [ ] #6 — Set up test framework and first smoke test

### Wave 3 (depends on Wave 2):
- [ ] #7 — Build POST /api/auth/register endpoint
- [ ] #8 — Build POST /api/auth/login endpoint
- [ ] #9 — Add JWT token generation and validation

### Wave 4 (depends on Wave 3):
- [ ] #10 — Build auth middleware
- [ ] #11 — Write auth integration tests
- [ ] #12 — Add email verification flow

### Wave 5 (verification):
- [ ] #13 — QA: E2E test for registration → verification → login
- [ ] #14 — Security: Review auth implementation, password handling, token security
```

PM presents the wave plan to the human for review. Human approves or adjusts.

### Gate — `🤖 Agent (PM)`

- [ ] All requirements have corresponding GitHub issues.
- [ ] Issues are assigned to milestones and sized atomically.
- [ ] Truth conditions are defined for each milestone in `.planning/STATE.md`.
- [ ] Wave plans are defined for each milestone in `.planning/STATE.md`.
- [ ] First milestone issues are prioritized and in `To Do`.
- [ ] Human has reviewed and approved the plan.

---

## Phase 4: Development

### Goal

Build the application milestone by milestone, using fresh sub-agents for each task, wave-based execution for parallelism, and truth conditions for verification.

### Execution Model

```
PM (Orchestrator) — stays light, delegates everything
│
├── Wave 1: PM spawns sub-agents for each independent task
│   ├── Sub-agent A (Developer) → Task #1 → commit → report back
│   ├── Sub-agent B (Developer) → Task #2 → commit → report back
│   └── Sub-agent C (DevOps)    → Task #3 → commit → report back
│
├── PM verifies Wave 1 complete, runs tests, updates STATE.md
│
├── Wave 2: PM spawns sub-agents for dependent tasks
│   ├── Sub-agent D (Developer) → Task #4 → commit → report back
│   └── Sub-agent E (Developer) → Task #5 → commit → report back
│
├── ... (repeat for each wave)
│
├── Final Wave: Verification
│   ├── Sub-agent (QA) → E2E tests, acceptance criteria
│   └── Sub-agent (Security) → Security review
│
└── PM runs truth condition check → Milestone checkpoint
```

### Sub-Agent Task Loop (Each Task)

For **each task**, the PM spawns a fresh sub-agent with a clean context:

```
┌──────────────────────────────────────────────────────────────────┐
│  PM prepares the sub-agent handoff:                              │
│  - Task description + acceptance criteria                        │
│  - Relevant source files (ONLY what's needed for this task)      │
│  - CLAUDE.md (golden rules, tech stack)                          │
│  - Relevant section of ARCHITECTURE.md                           │
│                                                                  │
│  Sub-agent executes (with fresh, full context):                  │
│  1. Creates a feature branch (feat/<issue>)                      │
│  2. Implements the feature                                       │
│  3. Writes/updates tests (unit + integration)                    │
│  4. Runs ALL tests (not just new ones)                           │
│  5. If tests fail → fixes before proceeding                      │
│  6. Updates documentation if behavior changed                    │
│  7. Commits with conventional commit message                     │
│                                                                  │
│  Sub-agent reports back to PM:                                   │
│  - Summary of what was done                                      │
│  - Files changed                                                 │
│  - Tests added/modified                                          │
│  - Learnings appended to .planning/LEARNINGS.md (if any)         │
│  - Concerns ONLY if they require human escalation                │
│                                                                  │
│  PM triggers review (separate sub-agents for each reviewer):     │
│  8. Architect reviews: architecture & code quality               │
│  9. Security reviews: vulnerabilities & data handling            │
│ 10. QA validates: acceptance criteria & test coverage            │
│ 11. If reviewer requests changes → PM spawns Developer           │
│     sub-agent with the feedback (no human needed)                │
│ 12. All reviewers approve → PM merges to develop                 │
│ 13. PM updates .planning/STATE.md and moves issue to "Done"      │
└──────────────────────────────────────────────────────────────────┘
```

> **Note**: For small, low-risk issues (typos, config changes, minor UI tweaks), the PM can streamline the review — not every issue needs all three reviewers. But any issue touching auth, data handling, AI integration, or API contracts **must** get the full review.

> **Context management rule**: If the PM's own context exceeds ~60% utilization, it should start a new session, re-read `CLAUDE.md`, `.planning/STATE.md`, and `.planning/LEARNINGS.md`, and continue orchestrating. No work is lost because all state is in files.

### Milestone Checkpoint (After Completing Each Milestone)

At the end of each milestone, the PM coordinates a **team checkpoint**:

**Step 1: Truth Condition Verification (QA leads)**

QA verifies every truth condition defined in `.planning/STATE.md`:

```markdown
## v0.2 — Truth Condition Results

- [x] A new user can register, verify email, and log in. ✅ PASS
- [x] A logged-in user can trigger the core AI workflow. ✅ PASS
- [ ] If the AI API is down, user sees fallback message. ❌ FAIL — shows raw 500 error
- [x] AI service logs calls with token count and latency. ✅ PASS
- [x] Unauthorized user gets 401 on AI endpoint. ✅ PASS
```

If any truth condition fails, the **milestone is not complete** — regardless of whether all tasks are marked Done. PM creates fix issues and assigns them.

**Step 2: Team Reports**

1. **QA** reports: test results, coverage (flag areas below 80%), truth condition results.
2. **Security** runs a quick scan of all code merged in this milestone — flags concerns.
3. **Architect** verifies no architectural drift from the documented design.
4. **DevOps** confirms CI/CD pipeline is green and infra is stable.

**Step 3: PM Compiles Milestone Report for Human**

- Truth condition results (pass/fail).
- What's working (demo-ready features).
- What deviated from the spec or architecture (and why).
- Open questions or concerns from any agent.
- Any inter-agent conflicts that were resolved (and how).
- Any unresolved conflicts that need human input.
- Tooling reassessment — Are there MCP servers or skills that would help with the next milestone?

**Step 4: PM presents the report to the human** and waits for sign-off before starting the next milestone.

### E2E Testing Checkpoint (After v0.2+)

Once core features exist, add Playwright E2E tests for critical user flows:

- User registration → email verification → login → core action → logout.
- Admin login → user management → analytics view.
- Error scenarios: invalid inputs, expired sessions, unauthorized access.

### Key Development Rules

- **Standard dependencies are fine.** Use well-known libraries without asking (e.g., `zod`, `dayjs`, `bcrypt`). Only flag unusual or heavy dependencies (new ORMs, UI frameworks, paid services) to the PM.
- **No TODO/FIXME without a linked GitHub issue.** Every shortcut gets tracked.
- **Database migrations must be reversible.** Every `up` has a `down`.
- **API responses must follow the documented format.** No ad-hoc response shapes.
- **All environment variables must be documented** in `.env.example` as they're added.
- **Seed script must be maintained.** Keep it updated so anyone can spin up a working local instance.

### Gate — `🤖 Agent (PM)`

> Note: Individual milestone checkpoints within this phase already require human sign-off. This gate verifies all milestones are complete.

- [ ] All milestone issues are Done.
- [ ] Full test suite passes.
- [ ] Coverage meets or exceeds 80%.
- [ ] Human has signed off on each milestone.

---

## Phase 5: Quality & Security Hardening

### Goal

Systematic review of the complete application for bugs, security vulnerabilities, UX issues, and missing edge cases.

### Step 5.1 — Brainstorming Session

Agent performs a thorough review and logs issues in the GitHub Project backlog under these categories:

| Label         | What to Look For |
|---------------|------------------|
| `bug`         | Broken flows, incorrect behavior, state management issues, race conditions |
| `feature`     | Missing functionality that users would expect, convenience features |
| `ui`          | Layout issues, responsiveness, accessibility gaps, loading/empty/error states |
| `security`    | Vulnerabilities, missing validation, exposed data, insecure defaults |
| `performance` | Slow queries, unnecessary re-renders, unoptimized assets, missing pagination |
| `dx`          | Developer experience — missing types, unclear code, missing documentation |

### Step 5.2 — Deep Security Audit

Agent conducts a focused security review:

1. **Authentication & Session Management**
   - Password hashing is using bcrypt/argon2 with appropriate cost factor.
   - Sessions expire and refresh correctly.
   - Failed login attempts are rate-limited and logged.
   - Password reset flow is secure (time-limited tokens, one-time use).

2. **Authorization**
   - Every API endpoint enforces authorization.
   - No privilege escalation paths (e.g., user can't access admin routes).
   - Resource ownership is verified (users can only access their own data).

3. **Input Handling**
   - All inputs are validated and sanitized (server-side, not just client-side).
   - SQL injection protection (parameterized queries / ORM).
   - XSS protection (output encoding, CSP headers).
   - File upload validation (if applicable): type, size, content scanning.

4. **Data Protection**
   - PII is encrypted at rest.
   - All traffic is over HTTPS.
   - Sensitive data is never logged.
   - CORS is configured correctly (not `*` in production).

5. **Infrastructure**
   - Dependencies are audited (`npm audit` / `pip audit`).
   - No secrets in source code or git history.
   - Rate limiting on all public endpoints.
   - Security headers are set (HSTS, X-Frame-Options, etc.).

6. **AI-Specific Security**
   - AI API keys are not exposed in client-side code, network responses, or logs.
   - All AI calls route through the backend AI service layer (no direct frontend-to-OpenAI calls).
   - Prompt injection defenses: User input is sanitized/escaped before inclusion in prompts.
   - AI responses are validated before being displayed or used in business logic (no blind trust of AI output).
   - Chatbot topic guardrails are enforced server-side and cannot be bypassed by creative user input.
   - Per-user rate limits on AI endpoints prevent cost abuse.
   - AI usage costs are tracked and alerts are configured for unusual spikes.
   - Conversation history is stored securely and is scoped per-user (no cross-user data leakage).
   - Chatbot cannot be tricked into revealing system prompts, other users' data, or internal implementation details.

Agent logs every finding as a GitHub issue with label `security` and priority.

### Step 5.3 — Resolve Security & Critical Issues

Agent works through security and critical bug issues using the same Development Loop from Phase 4.

### Gate — `🧑 Human`

- [ ] Security audit is complete and documented.
- [ ] All critical and high-priority issues are resolved.
- [ ] Full test suite still passes after fixes.
- [ ] Human has reviewed the remaining backlog and is comfortable with what's deferred.

---

## Phase 6: Deployment & Launch Prep

### Goal

Get the application running in a production(-like) environment with monitoring.

### Step 6.1 — Production Deployment Scripts

Agent creates production-ready deployment scripts:

**`scripts/deploy.sh`** — The main deployment script that:
1. Runs the full test suite (abort on failure).
2. Runs linting and type-checking (abort on failure).
3. Builds the production artifacts.
4. Runs database migrations.
5. Deploys to the production domain.
6. Runs a post-deployment smoke test (health check, key endpoints).
7. Outputs a deployment summary (version, timestamp, commit hash).

**`scripts/deploy-rollback.sh`** — Rollback script that:
1. Identifies the previous deployment version.
2. Reverts to the previous build/image.
3. Rolls back database migrations if needed (or confirms backward compatibility).
4. Runs the smoke test to verify rollback.

**`scripts/seed.sh`** — Seeds the database with:
1. Admin account (credentials from env vars).
2. Sample data for development/demo purposes.
3. Configurable for different environments (dev vs staging vs production).

### Step 6.2 — Production Domain & Infrastructure

1. Configure the production domain (provided in inputs).
2. Set up DNS records pointing to the hosting provider.
3. Configure SSL/TLS (auto-renewal via Let's Encrypt or provider-managed).
4. Set up CI/CD pipeline (GitHub Actions recommended):
   - On push to `develop`: Run tests, lint, type-check.
   - On merge to `main`: Run tests → build → deploy via `scripts/deploy.sh`.
5. Configure production environment variables (including AI API keys).
6. Set up monitoring / error tracking (Sentry or equivalent).
7. Set up health check endpoint (`/api/health`) that verifies:
   - Application is running.
   - Database is connected.
   - AI API is reachable (lightweight ping, not a full completion).
8. Configure logging for production (structured JSON logs, appropriate levels).
9. Set up AI cost monitoring alerts (daily/weekly spend thresholds).

### Step 6.3 — Pre-Launch Checklist

Agent runs through and confirms:

- [ ] All tests pass in CI.
- [ ] Production domain is live and resolves correctly.
- [ ] SSL certificate is valid and auto-renewing.
- [ ] `scripts/deploy.sh` executes successfully end-to-end.
- [ ] `scripts/deploy-rollback.sh` has been tested.
- [ ] Production environment variables are configured (including `OPENAI_API_KEY`).
- [ ] Database is migrated and seeded (if applicable).
- [ ] Health check endpoint responds at `https://[production-domain]/api/health`.
- [ ] Error tracking is receiving test events.
- [ ] Security headers are set.
- [ ] Rate limiting is active (including AI endpoints).
- [ ] AI API calls are working in production (test one core AI feature).
- [ ] AI cost alerts are configured.
- [ ] Admin account is created.
- [ ] `.env.example` is up to date (including all AI-related env vars).
- [ ] README has correct local setup and deploy instructions.

### Step 6.4 — Demo Script

Create `docs/DEMO.md`:

1. **Setup instructions** — How to get the demo environment running.
2. **Demo walkthrough** — Step-by-step script for presenting the MVP:
   - Open the app → Registration flow → Core AI-powered feature → Smart suggestions in action → Chatbot interaction → Profile management → Admin panel → AI usage dashboard.
3. **Talking points** — For each screen, note what to highlight (especially AI features).
4. **Known limitations** — What's not in the MVP and what's next.
5. **Sample data** — Describe or provide seed data that makes the demo compelling.

### Gate — `🧑 Human`

- [ ] Application is deployed and accessible at the production domain.
- [ ] Deploy and rollback scripts work correctly.
- [ ] Monitoring and AI cost alerts are active.
- [ ] Demo script is written and tested.
- [ ] Human has walked through the demo.

---

## Phase 7: Iteration & Backlog

### Goal

Transition from "building the MVP" to "improving the product."

### Actions

1. Review the remaining backlog from Phase 5.
2. Conduct a retrospective:
   - What went well?
   - What was painful?
   - What would we do differently next time?
3. Prioritize the backlog for the next development cycle.
4. Update `PRODUCT_SPEC.md` with any scope changes or new learnings.
5. Archive completed milestones.

This phase is ongoing and follows the same Development Loop from Phase 4.

---

## Appendix A: File Reference

| File                     | Purpose                                              | Created In |
| ------------------------ | ---------------------------------------------------- | ---------- |
| `CLAUDE.md`              | Agent instructions, golden rules, tech stack         | Phase 2    |
| `README.md`              | Project overview, setup guide, links                 | Phase 2    |
| `.planning/STATE.md`     | Orchestrator state: milestones, waves, truth conditions, progress | Phase 3 |
| `.planning/LEARNINGS.md` | Accumulated team knowledge — patterns, gotchas, conventions | Phase 4 |
| `docs/PRODUCT_SPEC.md`   | Full product specification with requirements         | Phase 1    |
| `docs/ARCHITECTURE.md`   | Technical architecture, data model, API design, AI architecture | Phase 2    |
| `docs/DEMO.md`           | MVP demo walkthrough script                          | Phase 6    |
| `scripts/deploy.sh`      | Production deployment script                         | Phase 6    |
| `scripts/deploy-rollback.sh` | Rollback to previous deployment                  | Phase 6    |
| `scripts/seed.sh`        | Database seed script                                 | Phase 4    |
| `skills/`                | Downloaded skill files for agent reference            | Phase 2    |
| `.env.example`           | Environment variable template (including AI keys)    | Phase 2    |

---

## Appendix B: Labels for GitHub Issues

Set these up in the repo during Phase 0:

| Label           | Color     | Description                        |
| --------------- | --------- | ---------------------------------- |
| `feature`       | `#1D76DB` | New functionality                  |
| `bug`           | `#D73A4A` | Something is broken                |
| `security`      | `#E4E669` | Security vulnerability or hardening|
| `ui`            | `#D4C5F9` | UI/UX improvement                  |
| `testing`       | `#0E8A16` | Test coverage or test infrastructure|
| `documentation` | `#0075CA` | Documentation updates              |
| `infrastructure`| `#F9D0C4` | CI/CD, deployment, tooling         |
| `performance`   | `#FEF2C0` | Performance optimization           |
| `dx`            | `#C5DEF5` | Developer experience improvement   |
| `ai`            | `#7B61FF` | AI features, prompts, chatbot, model tuning |

---

## Appendix C: Conventional Commit Prefixes

| Prefix       | Use When                                 |
| ------------ | ---------------------------------------- |
| `feat:`      | Adding a new feature                     |
| `fix:`       | Fixing a bug                             |
| `docs:`      | Documentation changes                    |
| `test:`      | Adding or updating tests                 |
| `refactor:`  | Code change that doesn't fix a bug or add a feature |
| `chore:`     | Tooling, config, dependencies            |
| `style:`     | Formatting, no code change               |
| `perf:`      | Performance improvement                  |
| `ci:`        | CI/CD pipeline changes                   |
| `security:`  | Security fix or hardening                |

---

## Appendix D: Future Automation (Post-v1.0)

These autonomous pipelines are **not part of the MVP build**. They are documented here for Phase 7 (Iteration & Backlog) once the product is stable, the test suite is trustworthy, and the team has confidence in the codebase.

### Autonomous Pipelines to Consider

| Pipeline | Trigger | What It Does | Prerequisites |
|----------|---------|-------------|---------------|
| **Nightly Security Scan** | Cron (daily) | Spawns a Security agent to run `npm audit` / dependency checks, scan for new CVEs affecting the stack, and create GitHub issues for findings. | Stable codebase, Security agent prompt tested |
| **Dependency Update Bot** | Cron (weekly) | Spawns a Developer agent to check for outdated dependencies, update them in a branch, run tests, and open a PR if tests pass. | High test coverage (90%+), stable CI |
| **Doc Sync Check** | On merge to `main` | Spawns an agent to verify README, ARCHITECTURE.md, and API docs are still accurate after code changes. Creates issues for drift. | Docs established and baselined |
| **AI Cost Monitor** | Cron (daily) | Queries AI API usage, compares against budget thresholds, and alerts (via GitHub issue or notification) if spend is trending above target. | AI usage tracking in production |
| **Backlog Grooming** | Cron (weekly) | Spawns a PM agent to review stale issues (no activity in 14+ days), add comments asking for status, and suggest deprioritization or closure. | GitHub Project board active |
| **Ralph Loop for Bug Fixes** | Manual trigger | For low-risk bug fix batches: run a Ralph-style loop that picks bugs from the backlog, fixes them, runs tests, and commits — autonomously until the batch is done. | High test coverage, bugs are well-defined, human reviews PR before merge |

### When to Enable These

- **After v1.0 is shipped** and the product is running in production.
- **After the test suite is comprehensive** — these pipelines rely on tests as the safety net.
- **Start with read-only pipelines** (security scan, doc sync, cost monitor) before enabling write pipelines (dependency updates, bug fixes).
- **Always review PRs** from autonomous pipelines before merging — treat them like contributions from a new team member.

### Ralph Loop: When It Makes Sense

The Ralph Loop pattern (autonomous iteration until done) becomes valuable post-MVP for:

- **Bug fix sprints** — Give it 20 well-defined bugs, let it chew through them overnight.
- **Refactoring passes** — "Convert all class components to functional components."
- **Test coverage drives** — "Write missing unit tests for all files in `/api/`."

**Not recommended for**: New feature development, architectural changes, security-sensitive code, or anything requiring product judgment. These still need the full team structure with human gates.
