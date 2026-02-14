# Orchestrating AI Coding Agents: A Framework for Building Production Software with Autonomous Agent Teams

**A whitepaper on the principles, patterns, and architecture behind structured AI-assisted application development.**

---

## Abstract

The emergence of AI coding agents — tools like Claude Code, Codex, and similar systems that can autonomously write, test, and deploy software — has created a gap between what these tools *can* do and what they *reliably* do. Left unstructured, AI agents produce inconsistent results: they drift from specifications, accumulate context that degrades their output quality, skip security reviews in favor of shipping speed, and make product decisions that should belong to humans.

This paper presents a framework for organizing AI coding agents into a structured, multi-role team that operates autonomously within defined boundaries. The framework addresses five core challenges: maintaining output quality across long projects (context management), ensuring security and architectural consistency (adversarial review), keeping humans in control of product decisions without micromanaging implementation (graduated autonomy), building AI-powered products using AI agents (recursive AI integration), and accumulating institutional knowledge across sessions (persistent learning).

The framework was developed through iterative design and draws on concepts from the GSD (Get Shit Done) framework, the Ralph Wiggum autonomous iteration pattern, and established software engineering practices adapted for the unique constraints of AI agent orchestration.

The result is a playbook that a technical product owner can hand to a single Claude Code instance. The instance then self-organizes into a team of specialized agents and builds a complete, production-ready application — from idea to deployment — with human involvement limited to strategic decision points.

---

## 1. The Problem Space

### 1.1 The Failure Modes of Unstructured AI Coding

When developers use AI coding agents without structure, they encounter predictable failure modes:

**Specification Drift.** The agent starts building what it *thinks* you want rather than what you *said* you want. Without a written spec that the agent references continuously, the product diverges from the original vision with each implementation decision. By the time the human notices, significant rework is required.

**Context Rot.** As an AI agent works in a single session, its context window fills with conversation history, code snippets, error messages, and debugging attempts. The quality of its output degrades progressively. A task executed in the first hour of a session will be materially better than the same complexity task executed in the tenth hour. This is not a theoretical concern — it is the most common failure mode in long-running agent sessions.

**Security Blindness.** AI agents are biased toward making things work. When an agent writes code and then reviews its own code, it is structurally incapable of adversarial review. It will not find the SQL injection vulnerability it just introduced because it was focused on the feature, not the attack surface. Security requires a separate perspective — ideally a hostile one.

**Decision Creep.** Without clear boundaries on what the agent can decide autonomously, one of two things happens: either the agent asks for permission on every file edit (destroying productivity) or it makes product-level decisions silently (destroying trust). Both outcomes are bad. The challenge is finding the boundary between these extremes.

**Knowledge Loss.** Each new session starts from zero. The agent rediscovers the same gotchas, reimplements the same patterns, and makes the same mistakes. There is no institutional memory unless it is explicitly engineered.

### 1.2 The Overcorrection: Enterprise Theater

Some frameworks attempt to solve these problems by importing heavyweight methodologies — sprint planning, retrospectives, story points, acceptance criteria reviews, architecture decision records, and multi-stage approval workflows. While well-intentioned, these approaches introduce a different failure mode: they make the agent spend more time performing process than building product.

A solo developer using an AI agent does not need a Scrum board. They need structure that prevents the specific failure modes listed above without adding overhead that slows them down. The goal is not process for its own sake — it is process that directly addresses a known failure mode.

### 1.3 The Design Principle

Every element of the framework described in this paper exists because it solves a specific, named problem. If a practice cannot be traced back to a concrete failure mode it prevents, it does not belong in the framework.

| Practice | Failure Mode It Prevents |
|----------|--------------------------|
| Written product specification with human review | Specification drift |
| Fresh sub-agent contexts per task | Context rot |
| Multi-role team with Security override authority | Security blindness |
| Explicit autonomy boundaries | Decision creep |
| Persistent learnings file | Knowledge loss |
| Atomic task sizing | Context rot (per-task) |
| Truth conditions | Verification theater (tasks "done" but product broken) |
| Human gates at strategic points | Loss of product control |
| Wave-based execution | Dependency conflicts and blocked work |

---

## 2. The Multi-Agent Team Model

### 2.1 Why Roles Matter in a Single Instance

The framework assigns six distinct roles to agents operating within a single Claude Code instance: PM (Project Manager), Architect, Developer, QA (Quality Assurance), Security, and DevOps. This may seem artificial — after all, it is one AI instance talking to itself. But the role separation serves a critical function: it creates **adversarial review**.

When a single agent writes code and reviews it, the review is performative. The agent already "agrees" with its own implementation. But when the same instance is instructed to adopt the Security role and review its own Developer work with explicit instructions to look for vulnerabilities, the quality of the review materially improves. The role creates a different evaluation lens.

This is analogous to how a senior engineer can simultaneously hold the perspective of "person who wrote this code" and "person reviewing a pull request" — but only if they consciously switch modes. The role assignments force this mode-switching.

### 2.2 Role Definitions

**PM (Project Manager)** is the orchestrator and the only role that communicates with the human. The PM owns the specification, the plan, the timeline, and the delegation of work. The PM does not write code. The PM's primary function is to make decisions about *what* to build and *when*, coordinate the team, and escalate to the human only when necessary.

**Architect** owns the technical design. The Architect decides the tech stack, defines the data model, designs the API contracts, and reviews all code for architectural consistency. When the Developer proposes an implementation approach, the Architect validates it against the established architecture before work begins. This prevents architectural drift — the gradual divergence of implementation from design that occurs when individual contributors make local decisions without a global view.

**Developer** writes the application code and the unit and integration tests. The Developer works within the boundaries set by the Architect and follows the golden rules defined in the project's instruction file. The Developer does not make architectural decisions, does not skip tests, and does not merge code without review.

**QA** writes end-to-end tests, validates that acceptance criteria are met, and tries to break things. QA's value is that it approaches the product from the user's perspective, not the builder's perspective. QA tests observable behaviors — can the user register, can the user complete the core workflow — rather than implementation details.

**Security** reviews all code for vulnerabilities. Security owns the security audit, reviews authentication flows, validates input sanitization, checks for data leakage, and audits AI-specific risks like prompt injection and system prompt exposure. Security has a special authority in the framework: in disputes with the Developer, Security wins by default unless the human explicitly overrides.

**DevOps** owns the infrastructure: CI/CD pipelines, deployment scripts, environment configuration, database operations, health checks, and monitoring. DevOps ensures that what works in development also works in production.

### 2.3 The Security Override Principle

The decision to give Security default override authority over the Developer is deliberate. In practice, when an agent plays both Developer and Security, there is an inherent bias toward shipping. The Developer "wants" the feature to work; the Security review is an obstacle. Without an explicit hierarchy, the agent will tend to rationalize security concerns away ("this is an internal endpoint, we can add auth later").

By establishing that Security wins disputes unless the human overrides, the framework creates a structural bias toward safety. The human remains the ultimate authority — they can always decide that a security concern is acceptable for the current context — but the default state is secure.

This mirrors how mature engineering organizations operate: the security team can block a release, and only a VP-level decision can override that block.

### 2.4 Conflict Resolution Hierarchy

Not all disagreements require human intervention. The framework defines a clear hierarchy:

**Minor conflicts** (PM resolves autonomously): Code style disagreements, implementation approach when both options satisfy requirements, test strategy details, task prioritization within a milestone. These are routine engineering decisions that a senior PM would resolve without escalating.

**Major conflicts** (escalate to human): Scope changes, requirement reinterpretation, tech stack changes, new dependency additions, timeline-impacting disagreements, architectural pivots. These are decisions that affect the product's direction or the human's investment.

**Security disputes** (Security wins by default): When Security identifies a vulnerability, the Developer must fix it. The only override is the human explicitly accepting the risk.

The escalation format is structured: the PM presents the conflict, both positions with reasoning, and a recommendation. The human decides. This ensures the human has full context without needing to trace through the entire conversation.

---

## 3. Context Engineering

### 3.1 The Context Rot Problem

Context rot is the most technically significant challenge in long-running AI agent sessions. As the context window fills with conversation history — prompts, responses, code blocks, error messages, debugging sessions — the agent's ability to maintain coherence degrades. Instructions from early in the session are "pushed out" of effective attention. The agent begins contradicting its own earlier decisions, forgetting architectural constraints, and producing lower-quality code.

Research and practitioner experience (particularly from the GSD framework community) suggests that agent output quality begins degrading noticeably after 40-50% context utilization and becomes unreliable above 70%.

### 3.2 The Fresh Sub-Agent Model

The framework addresses context rot with a principle borrowed from the GSD framework: **the orchestrator stays light; workers get fresh context.**

The PM (orchestrator) does not write code. For each task, the PM spawns a fresh sub-agent — a new invocation with a clean, full context window. The sub-agent receives only what it needs for the specific task: the task description, relevant source files, the project instruction file (CLAUDE.md), and the relevant section of the architecture document. The sub-agent does its work, commits, reports results back to the PM, and its context is discarded.

This means the 50th task in a project gets the same quality context as the 1st task. The PM's own context stays light because it holds only orchestration state — task queues, progress tracking, decisions — not implementation details.

### 3.3 Persistent State via Files

If each sub-agent has a fresh context, how does the team maintain continuity? The answer is files. All state that needs to persist across sessions and sub-agents is written to the filesystem:

**`.planning/STATE.md`** tracks the orchestrator's state: the current milestone, completed tasks, in-progress tasks, blocked tasks, wave plans, truth conditions, and key decisions. When the PM's context gets heavy or a new session begins, the PM reads this file to restore its working state. Nothing is lost because the source of truth is on disk, not in context.

**`.planning/LEARNINGS.md`** accumulates team knowledge across iterations — an idea borrowed from the Ralph pattern's `AGENTS.md`. After each task, the executing agent appends any useful discoveries: patterns found in the codebase, gotchas encountered, conventions established, workarounds applied. This file is included in every sub-agent's context, so the team benefits from past experience.

**`CLAUDE.md`** is the project instruction file — the golden rules, tech stack, architecture summary, and team structure. It is the first thing every sub-agent reads. It defines the invariants that all agents must respect regardless of what specific task they are working on.

These three files form the team's **institutional memory**. They replace the context window as the source of truth and enable the team to operate across arbitrarily many sessions without degradation.

### 3.4 The 60% Rule

The framework specifies that if the PM's context utilization exceeds approximately 60%, it should start a new session. The PM reads CLAUDE.md, STATE.md, and LEARNINGS.md, and continues orchestrating from where it left off. This is a proactive measure — it prevents degradation rather than recovering from it.

In practice, this means the PM might start 3-5 sessions over the course of building a full application, while spawning dozens of sub-agents. The sessions are cheap (a few minutes of re-reading state); the alternative (degraded orchestration quality) is expensive.

---

## 4. Task Design: Atomicity, Waves, and Truth Conditions

### 4.1 Atomic Task Sizing

For the fresh sub-agent model to work, each task must be small enough for a single sub-agent to complete without context degradation. The framework defines "atomic" tasks with specific constraints:

- Each task should touch three or fewer files in its core change (tests and documentation don't count toward this limit).
- The task description plus relevant source files plus CLAUDE.md should fit within 50% of the context window. If it doesn't, the task needs to be split.
- Each task does one thing: add an endpoint, write a migration, build a component. Compound tasks like "build the whole authentication system" must be decomposed.
- Each task must be independently testable. If you cannot write a test for a task in isolation, the task is too vague.

These constraints directly serve context management. A task that fits in 50% of context leaves the other 50% for the agent's reasoning, code generation, and test writing. A task that touches three or fewer files is small enough to hold entirely in working memory.

The anti-pattern is "Implement user authentication" as a single task. The correct decomposition is: create users table migration, add password hashing utility, build registration endpoint, build login endpoint, add JWT generation and validation, write auth middleware, write integration tests. Each of these is independently implementable, testable, and reviewable.

### 4.2 Wave-Based Execution

Within each milestone, the PM organizes tasks into **waves** based on their dependency relationships. A wave is a set of tasks that are independent of each other — they can be executed in any order (or in parallel) without conflicts. A wave starts only after the previous wave is fully complete.

This concept addresses two problems. First, it prevents dependency conflicts — a developer sub-agent trying to build an API endpoint before the database schema exists. Second, it creates natural verification points — the end of each wave is an opportunity to run tests and verify that the foundation is solid before building on top of it.

The final wave of every milestone is always a verification wave: QA writes end-to-end tests and validates acceptance criteria; Security reviews the code merged during the milestone.

### 4.3 Goal-Backward Verification (Truth Conditions)

Traditional project management asks: "Did we complete all the tasks?" This is a necessary but insufficient check. All tasks can be marked done while the product is broken — tests might pass individually but the end-to-end workflow might fail; a feature might be implemented but unusable due to a UX issue; an edge case might crash the application.

The framework introduces **truth conditions**, borrowed from the GSD framework's goal-backward verification approach. Before starting a milestone, the PM defines a set of observable, testable statements that must be true when the milestone is complete:

- "A new user can register, verify email, and log in."
- "If the AI API is down, the user sees a graceful fallback message."
- "An unauthorized user cannot access the AI endpoint."

These are not implementation tasks — they are *outcomes*. QA verifies each truth condition independently at the milestone checkpoint. If a truth condition fails, the milestone is not complete, regardless of how many tasks are checked off.

This creates a stronger verification loop than task completion alone. Tasks are how you get there; truth conditions are how you know you've arrived.

---

## 5. The Autonomy Spectrum

### 5.1 The Fundamental Tension

There is an inherent tension between two goals: keeping the human in control of their product, and not requiring the human to approve every file edit. AI coding agents run with either too much permission (they make product decisions the human didn't authorize) or too little permission (the human must click "approve" hundreds of times per session).

The framework resolves this by defining an explicit **autonomy boundary** based on a simple heuristic: **if a senior engineer at a real company would just do it without scheduling a meeting, the agent should just do it. If they would message the product owner first, the agent should ask.**

### 5.2 What the Team Decides Autonomously

The team makes all routine engineering decisions without consulting the human:

- Implementation details: which function to write, how to structure a component, where to put a file.
- Library choices for standard needs: date formatting, validation, hashing, HTTP clients.
- Refactoring decisions within the existing architecture.
- Test strategy: what to test, how to mock, what edge cases to cover.
- Bug fixes that are clearly within the existing spec — the expected behavior is defined, the code doesn't match it, the fix is straightforward.
- Code review feedback: the Architect telling the Developer to rename a variable or extract a function.
- Task sequencing within an approved wave plan.

These decisions are *implementation* — they affect how the product is built, not what it is.

### 5.3 What Requires Human Consultation

The team escalates to the human for decisions that affect the product's direction, scope, cost, or risk profile:

- **Human gates** (defined checkpoints at the end of Phases 1, 2, 5, and 6) where the human reviews and approves major deliverables.
- **Scope changes or pivots** — anything that deviates from the approved specification.
- **Product or design questions** not answered by the spec — "Should the chatbot be visible to unauthenticated users?"
- **New service integrations** that require API keys — the agent cannot assume access to a service. It must request the key, explain why it's needed, and propose a fallback if denied.
- **New tooling requests** — MCP servers or skill files that the agent wants to install.
- **Major inter-agent conflicts** that the PM cannot resolve — scope reinterpretations, architectural pivots, timeline impacts.
- **Persistent truth condition failures** — if a truth condition fails and the team cannot fix it within three attempts, the problem likely requires a product-level decision.

### 5.4 The Service Keys Protocol

A specific application of the autonomy boundary is the Service Keys Protocol. AI agents cannot assume that external services are available. If the Developer determines that the application needs email delivery (Resend), file storage (S3), or any third-party service, the PM must:

1. Identify the need and explain the justification.
2. Request the API key from the human.
3. Propose a fallback if the key is denied (use console logging instead of email, use local filesystem instead of S3).
4. Wait for the human's response before proceeding.
5. If denied, implement the fallback — never build features that depend on services the team doesn't have access to.

This prevents a common failure mode where the agent writes integration code for a service, discovers it doesn't have credentials, and either leaves broken code in the codebase or asks for the key after the feature is half-built.

---

## 6. Phased Development

### 6.1 Why Phases Matter

The framework is organized into seven sequential phases, each with a clear gate. The phases exist to prevent a specific anti-pattern: the agent jumping to implementation before the specification is clear, or deploying before security is verified.

Each phase produces artifacts that feed into the next phase. The spec feeds the architecture. The architecture feeds the task breakdown. The task breakdown feeds development. This creates a traceable chain from requirement to implementation.

### 6.2 Phase Structure

**Phase 0: Project Initialization** — Collect inputs (project name, idea, repository, domain, API keys), scaffold the folder structure, initialize git. Gate: PM verifies all inputs are present.

**Phase 1: Product Specification** — Draft a comprehensive product spec through iterative dialogue with the human: user stories, functional requirements, non-functional requirements, admin panel features, AI integration tiers. Gate: Human reviews and approves the spec.

**Phase 2: Architecture & Technical Design** — Decide the tech stack, design the data model, define API contracts, plan the AI service layer architecture, identify MCP servers and skills, write the CLAUDE.md instruction file. Gate: Human reviews and approves the architecture.

**Phase 3: Task Breakdown & Planning** — Define milestones with truth conditions, decompose requirements into atomic GitHub issues, organize issues into waves. Gate: PM verifies completeness; human reviews the plan.

**Phase 4: Development** — Execute wave by wave, milestone by milestone, using fresh sub-agents. Cross-agent review on every merge. Milestone checkpoints with truth condition verification. Gate: PM verifies all milestones complete; each milestone requires human sign-off.

**Phase 5: Quality & Security Hardening** — Comprehensive security audit (including AI-specific risks), brainstorming session for edge cases, performance review. Gate: Human reviews security findings.

**Phase 6: Deployment & Launch Prep** — Production deployment scripts, domain and infrastructure setup, pre-launch checklist, demo script. Gate: Human approves for launch.

**Phase 7: Iteration & Backlog** — Retrospective, backlog grooming, continuous improvement. No gate — this is ongoing.

### 6.3 Gate Design Philosophy

Gates serve two purposes: quality assurance and human control. The framework assigns gates to either the human or the PM agent based on the type of decision involved.

**Human gates** are placed where the decision is *strategic*: approving the product spec (Phase 1), approving the architecture (Phase 2), accepting the security posture (Phase 5), and authorizing deployment (Phase 6). These are decisions that require product judgment, risk assessment, or business context that the agent does not have.

**Agent (PM) gates** are placed where the check is *procedural*: verifying that all inputs are collected (Phase 0), confirming all requirements have issues (Phase 3), validating that all milestones are complete (Phase 4). These are checklist verifications that the PM can perform autonomously.

The human can always override an agent gate — but the expectation is that they won't need to if the checklist is complete.

---

## 7. AI Integration Architecture

### 7.1 The Recursive Challenge

Building AI-powered products using an AI coding agent creates a recursive challenge. The agent must understand AI integration not as an abstract concept but as a concrete architectural pattern: where API calls go, how prompts are managed, how costs are tracked, and how the product gracefully degrades when the AI provider is unavailable.

### 7.2 The Three-Tier AI Model

The framework defines three tiers of AI integration, each with different architectural requirements:

**Tier 1: Core Business Logic** — AI capabilities that are central to the product's value proposition. Example: an AI that analyzes uploaded documents and generates summaries. These are the features that make the product worth using. They require the most powerful model, the most careful prompt engineering, and the most robust fallback handling.

**Tier 2: Smart Suggestions** — Context-aware, proactive AI features that enhance the user experience but are not essential. Example: autocomplete suggestions, smart defaults, content recommendations. These can use lighter (cheaper) models and can degrade gracefully to manual input.

**Tier 3: In-App Chatbot** — A conversational AI interface scoped to the application's domain. The chatbot must be constrained: it should answer questions about the product and the user's data, not arbitrary questions. This requires server-side topic guardrails, conversation memory (stored in the database, not just in the prompt), and explicit boundaries on what the chatbot will and will not discuss.

### 7.3 The AI Service Layer Pattern

All AI API calls must go through a centralized service layer — never directly from routes, controllers, or frontend code. This pattern provides several benefits:

- **Single point of control** for model selection, prompt management, and fallback logic.
- **Centralized logging** of every API call: user, model, tokens consumed, latency, cost.
- **Cost controls** — rate limiting, budget caps, and usage alerts.
- **Swappable providers** — if the team needs to switch from OpenAI to another provider, only the service layer changes.
- **Testability** — the service layer can be mocked in tests, so the test suite doesn't depend on a live AI API.

### 7.4 AI-Specific Security Concerns

AI integration introduces security risks that traditional web applications do not face:

- **Prompt injection** — malicious user input that manipulates the AI's behavior by injecting instructions into the prompt.
- **System prompt exposure** — the AI revealing its system prompt in response to crafted queries.
- **Data leakage** — the AI including sensitive data from other users' contexts in its responses.
- **Cost abuse** — a malicious user triggering expensive API calls at scale.
- **PII in prompts** — personal data being sent to third-party AI providers.

The framework requires the Security agent to audit all AI integration points for these specific risks during Phase 5.

---

## 8. Tooling Augmentation

### 8.1 MCP Servers

Model Context Protocol (MCP) servers extend the agent's capabilities by providing structured access to external tools and services. The framework distinguishes between two categories:

**Development MCP servers** help the agent build faster — direct database access (Postgres MCP), programmatic issue management (GitHub MCP), file system tools. These augment the agent's development workflow.

**Product MCP servers** power features in the running application — browser automation, data connectors, third-party API integrations. These become part of the deployed product.

Each MCP server requires human approval before installation. The agent proposes it with a justification and a fallback approach, and the human approves or denies. This prevents the agent from installing tools that the human doesn't want in their environment.

### 8.2 Skills Acquisition

Skills are specialized instruction sets — markdown files containing best practices, patterns, and guidelines for specific technologies or tasks. Examples: "Next.js App Router patterns," "Playwright E2E best practices," "OpenAI streaming implementation."

The agent can propose downloading skill files that would improve its output quality for the specific project. Each proposal includes the source, what it covers, and why it's relevant. Approved skills are stored in the repository's `skills/` directory so they are versioned, visible, and available to all sub-agents.

### 8.3 Tooling Reassessment

The framework specifies that the team should reassess its tooling needs at every milestone checkpoint. What was not needed at v0.1 may become valuable at v0.3. The milestone checkpoint is the natural point to propose new MCP servers, skills, or services — and to retire ones that turned out to be unnecessary.

---

## 9. Persistent Learning

### 9.1 The Knowledge Loss Problem

Every new AI agent session starts with a blank slate. The patterns discovered in session 1 — "this ORM doesn't support upserts," "the Tailwind ring utility conflicts with shadcn/ui," "the health check endpoint shouldn't call the AI API" — are lost when the session ends. The next session rediscovers these patterns, wasting time and potentially making the same mistakes.

### 9.2 The Learnings File

The framework addresses this with `.planning/LEARNINGS.md`, inspired by the Ralph pattern's `AGENTS.md`. After every task, the executing agent appends useful discoveries to this file:

- **Patterns discovered**: "This codebase uses X for Y."
- **Gotchas**: "Do not forget to update Z when changing W."
- **Conventions established**: "All date formatting uses dayjs with UTC."
- **Workarounds**: "The CI runner doesn't have enough memory for the full E2E suite; split into shards."

This file is included in every sub-agent's context. Over time, it becomes a growing body of project-specific knowledge that prevents repeated mistakes and accelerates development.

The key insight from the Ralph community is that AI coding tools automatically read instruction files. By structuring learnings in a file that agents read at session start, the knowledge transfer is automatic — no human intervention required.

---

## 10. Post-MVP Evolution

### 10.1 The Ralph Loop Pattern

The Ralph Wiggum technique — named after the stubbornly persistent Simpsons character — is an autonomous iteration pattern where the agent runs in a loop: pick a task, execute it, verify the result, repeat. Each iteration starts with fresh context. The loop continues until all tasks are complete or a safety limit is reached.

The framework deliberately does not use this pattern during MVP development. The reasons:

1. Ralph is designed for autonomous execution with minimal human oversight. The framework prioritizes human governance at strategic points.
2. Ralph's verification is typically automated (tests pass or fail). The framework's multi-agent review (Architect, Security, QA) provides deeper validation.
3. Ralph works best for well-defined, low-risk tasks. MVP development involves ambiguous requirements and security-sensitive decisions.

However, the framework documents Ralph as a post-v1.0 tool for specific use cases: bug fix sprints (give it 20 well-defined bugs, let it work overnight), refactoring passes (convert all class components to functional components), and test coverage drives (write missing tests for all files in a directory). These are tasks with clear success criteria, low risk, and no product judgment required.

### 10.2 Autonomous Pipelines

Post-MVP, the framework supports automated agent-driven maintenance pipelines:

- **Nightly security scans** — spawn a Security agent to run dependency audits and create issues for findings.
- **Weekly dependency updates** — spawn a Developer agent to update packages, run tests, and open a PR if tests pass.
- **Documentation sync checks** — after merges to main, verify that docs match the code and create issues for drift.
- **AI cost monitoring** — daily checks on API usage against budget thresholds.

These pipelines rely on a mature test suite as their safety net. They are explicitly documented as future work — not part of the MVP build — to prevent premature automation.

---

## 11. Constructing a Playbook from These Principles

The principles described in this paper can be assembled into a concrete, executable playbook. Here is how:

### 11.1 Define Inputs

Start by listing everything the human must provide before work begins: the project idea, a repository, any API keys (AI providers, external services), and the production domain. Everything the agent needs to begin should be collected upfront to prevent interruptions during execution.

### 11.2 Write the Phase Structure

Organize the development lifecycle into sequential phases with explicit gates. Each phase should produce specific, named artifacts that feed into the next phase. Assign each gate to either the human (strategic decisions) or the PM agent (procedural checklists).

A recommended structure:

1. **Initialization** (agent gate) — inputs collected, repo scaffolded, folder structure created.
2. **Product Specification** (human gate) — comprehensive spec written through iterative dialogue, requirements extracted and numbered.
3. **Architecture & Technical Design** (human gate) — tech stack decided, data model designed, API contracts defined, AI architecture specified, instruction file written.
4. **Task Breakdown** (agent gate) — milestones defined with truth conditions, issues created and sized atomically, waves planned.
5. **Development** (agent gate per milestone, human sign-off per milestone) — wave-by-wave execution with fresh sub-agents and cross-agent review.
6. **Quality & Security Hardening** (human gate) — comprehensive security audit, edge case brainstorming, AI-specific security review.
7. **Deployment** (human gate) — production scripts, domain setup, pre-launch checklist, demo.
8. **Iteration** (ongoing) — retrospective, backlog, continuous improvement.

### 11.3 Define the Team

List each role with its responsibilities, authority, and boundaries. Establish the conflict resolution hierarchy (PM resolves minor conflicts, human resolves major ones, Security overrides Developer by default). Create a phase ownership table mapping which role leads each phase.

### 11.4 Build the Instruction File Template

The project instruction file (CLAUDE.md or equivalent) is the agent's operating manual. It should include:

- Project overview (one-two sentences, link to spec).
- Team structure summary.
- Tech stack.
- Architecture summary (link to full architecture doc).
- Golden rules — non-negotiable behaviors. Number them. Make them imperative. Examples:
  - "Test everything."
  - "Never break the build."
  - "All AI calls go through the service layer."
  - "Every AI feature has a fallback."
  - "Act like a senior team — make routine decisions, escalate product decisions."
  - "Fresh context for every task."
  - "Truth conditions over task completion."
  - "Log learnings."

### 11.5 Define the Execution Model

Specify how tasks move from "to do" to "done":

1. PM assigns task to a sub-agent with fresh context.
2. Sub-agent creates a branch, implements, tests, commits.
3. Sub-agent reports results.
4. Appropriate reviewers (Architect, Security, QA) review.
5. If changes requested, a new sub-agent gets the feedback and fixes.
6. All reviewers approve, PM merges, state updated.

Define wave rules: independent tasks in the same wave, waves execute sequentially, final wave is verification.

Define context management rules: PM stays under 60% context, sub-agents get only what they need, state persists in files.

### 11.6 Define the Autonomy Boundary

Be explicit about what the team decides independently and what requires human consultation. Write both lists. The "do not stop for" list is as important as the "must stop for" list — it gives the agent confidence to act.

Use the senior engineer heuristic: if they would just do it, the agent should just do it. If they would ask the product owner, the agent should ask.

### 11.7 Add AI Integration Patterns (If Applicable)

If the product includes AI features, define:

- The tier model (core logic, suggestions, chatbot).
- The AI service layer pattern.
- Model selection per tier.
- Prompt management approach (prompts as code, versioned, reviewed).
- Fallback strategy for every AI feature.
- Cost tracking schema.
- AI-specific security audit checklist.

### 11.8 Add Protocols for External Dependencies

Define how the team handles new services (Service Keys Protocol), new tools (MCP Server and Skills Acquisition), and new dependencies (standard libraries are fine, unusual dependencies require justification).

### 11.9 Add Appendices

Include reference material that the team will need repeatedly:

- File reference (every file the playbook produces, its purpose, when it's created).
- Labeling taxonomy for issues (feature, bug, security, testing, documentation, infrastructure, ai).
- Commit message conventions.
- Future automation opportunities (post-MVP).

### 11.10 Review and Trim

Go through the entire playbook and apply the design principle from Section 1.3: every practice must trace to a specific failure mode. If a section exists because "good engineering practice" but does not address context rot, specification drift, security blindness, decision creep, or knowledge loss, consider removing it. The playbook should be as short as possible while preventing every failure mode it targets.

---

## 12. Conclusion

The framework described in this paper is not about making AI agents follow a process. It is about designing the right constraints so that AI agents produce reliable, secure, production-quality software while maintaining human control over product direction.

The key ideas are:

1. **Roles create adversarial review.** A single agent reviewing its own work is theater. Explicit role-switching creates genuine evaluation from different perspectives.

2. **Fresh context prevents rot.** The orchestrator stays light; workers get clean context. State lives in files, not in conversation history.

3. **Truth conditions prevent false completion.** Checking tasks off a list does not guarantee the product works. Testing observable outcomes does.

4. **Autonomy needs explicit boundaries.** Define what the team decides independently *and* what requires human input. Both lists are essential.

5. **Knowledge must persist.** Learnings files give the team institutional memory across sessions. The team gets smarter over time instead of starting from zero.

6. **Security must be structurally privileged.** Without an explicit override hierarchy, the agent's bias toward shipping will override security concerns. Make security the default winner.

7. **Every practice must earn its place.** If a process element doesn't prevent a specific, named failure mode, it is overhead. Remove it.

These principles are tool-agnostic. While the reference playbook was designed for Claude Code, the concepts apply to any AI coding agent that supports autonomous execution, sub-agent spawning, and file-based state management. The specific implementation details (CLAUDE.md vs. AGENTS.md, GitHub Issues vs. Linear, Next.js vs. other stacks) are interchangeable. The architecture of the process is what matters.

The goal is not to replace human judgment with AI process. It is to free human judgment for the decisions that actually require it — product vision, risk tolerance, user experience — while letting a well-structured AI team handle everything else.

---

## References & Influences

- **GSD (Get Shit Done) Framework** — by TÂCHES (glittercowboy). Open-source meta-prompting and context engineering system for Claude Code. Key contributions to this framework: fresh sub-agent contexts, aggressive atomicity, wave-based execution, goal-backward verification. GitHub: `glittercowboy/get-shit-done`

- **Ralph Wiggum Technique** — by Geoffrey Huntley. Autonomous iteration pattern for AI coding agents. Key contribution: the concept of a bash loop that runs agents repeatedly with fresh context until verification passes, and the learnings file pattern for persistent knowledge. GitHub: `ghuntley/how-to-ralph-wiggum`

- **Claude Code Best Practices** — by Anthropic. Official guidance on using Claude Code effectively, including headless mode, task management, and CLAUDE.md conventions. Source: `docs.anthropic.com`

---

*This paper documents the design rationale for the App Builder Playbook, a structured framework for building production-ready AI-powered applications using autonomous AI coding agent teams.*
