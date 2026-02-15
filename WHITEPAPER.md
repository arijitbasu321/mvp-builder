# Orchestrating AI Coding Agents: A Framework for Building Production Software with Autonomous Agent Teams

**A whitepaper on the principles, patterns, and architecture behind structured AI-assisted application development.**

---

## Abstract

The emergence of AI coding agents — tools like Claude Code, Codex, and similar systems that can autonomously write, test, and deploy software — has created a gap between what these tools *can* do and what they *reliably* do. Left unstructured, AI agents produce inconsistent results: they drift from specifications, accumulate context that degrades their output quality, skip security reviews in favor of shipping speed, and make product decisions that should belong to humans.

This paper presents a framework for organizing AI coding agents into a structured, multi-role team that operates autonomously within defined boundaries. The framework addresses six core challenges: maintaining output quality across long projects (context management), ensuring security and architectural consistency (adversarial review), keeping humans in control of product decisions without micromanaging implementation (graduated autonomy), building AI-powered products using AI agents (recursive AI integration), accumulating institutional knowledge across sessions (persistent learning), and recovering cleanly when fundamental assumptions break (pivot protocols).

The framework was developed through iterative design and draws on concepts from the GSD (Get Shit Done) framework, the Ralph Wiggum autonomous iteration pattern, Claude Code's native Agent Teams feature, and established software engineering practices adapted for the unique constraints of AI agent orchestration.

The result is a playbook that a technical product owner can hand to a Claude Code instance. The instance then self-organizes into a team of specialized roles — using Agent Teams as the required default execution model (with sub-agents via the Task tool or manual session management as fallbacks) — and builds a complete, production-ready application from idea to deployment, with human involvement limited to strategic decision points.

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
| Fresh worker contexts per task (Agent Teams, sub-agents, or manual sessions) | Context rot |
| Multi-role team with Security override authority | Security blindness |
| Explicit autonomy boundaries | Decision creep |
| Persistent learnings file | Knowledge loss |
| Persistent decision log | Decision relitigating across sessions |
| Atomic task sizing | Context rot (per-task) |
| Truth conditions | Verification theater (tasks "done" but product broken) |
| Human gates at strategic points | Loss of product control |
| Wave-based execution with file-independence checks | Dependency conflicts, parallel write conflicts |
| Recovery & pivot protocol | Grinding against broken assumptions |

---

## 2. The Multi-Agent Team Model

### 2.1 Why Roles Matter

The framework assigns six distinct roles: PM (Project Manager), Architect, Developer, QA (Quality Assurance), Security, and DevOps. The default execution model is Claude Code's native Agent Teams, where the PM operates as team lead and each role is fulfilled by an independent teammate. When Agent Teams is unavailable, sub-agents via the Task tool serve as a fallback, and manual session restarts as a last resort. While the execution model affects capability and efficiency, what matters most is the role separation itself, because it creates **adversarial review**.

When a single agent writes code and reviews it, the review is performative. The agent already "agrees" with its own implementation. But when a separate teammate reviews Developer work with instructions to look for vulnerabilities, the quality of the review materially improves. The role creates a different evaluation lens. Agent Teams makes this structurally robust in a way that sub-agents cannot: each teammate operates in its own independent context window, loads the project's CLAUDE.md automatically, maintains a persistent identity throughout the session, and communicates with other teammates via `SendMessage` rather than through a shared orchestrator. The Security reviewer is not merely a fresh context — it is a genuinely separate agent that never saw the implementation reasoning, only the output. It has its own loaded instructions, its own perspective, and its own judgment.

This is analogous to how a senior engineer can simultaneously hold the perspective of "person who wrote this code" and "person reviewing a pull request" — but only if they consciously switch modes. The role assignments force this mode-switching. Sub-agents simulate it with fresh contexts. Agent Teams enforces it structurally — each teammate is a distinct agent with its own identity, not a temporary subprocess that disappears after one task.

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

### 3.2 The Fresh Delegation Model

The framework addresses context rot with a principle borrowed from the GSD framework: **the orchestrator stays light; workers get fresh context.**

The PM (orchestrator) does not write code. For each task, the PM delegates to a worker with a clean, full context window. The worker receives only what it needs for the specific task: the task description, relevant source files, the project instruction file (CLAUDE.md), the relevant section of the architecture document, the learnings file, and the decision log. The worker does its work, commits, reports results back to the PM, and its context is discarded.

This means the 50th task in a project gets the same quality context as the 1st task. The PM's own context stays light because it holds only orchestration state — task queues, progress tracking, decisions — not implementation details.

The delegation model can be implemented at three levels of Claude Code capability:

**Agent Teams** (primary, required default) — Claude Code's native multi-agent feature. The PM acts as team lead and spawns teammates for each role. This is the required execution model for several reasons that go beyond convenience:

- *Independent context windows.* Each teammate gets its own full context window, completely isolated from the PM's orchestration state and from other teammates' work. This is not merely "fresh context" — it is parallel context. Five teammates working simultaneously means five full context windows operating at peak quality, compared to one context window being reused serially.
- *Automatic CLAUDE.md loading.* Every teammate automatically loads the project's CLAUDE.md, MCP servers, and skills when it starts. The PM does not need to manually inject instructions into each delegation — the teammate arrives with the project's golden rules, tech stack, and conventions already internalized.
- *Persistent identity.* A teammate maintains its role identity throughout its lifecycle. A Security teammate does not need to be reminded it is playing the Security role on each interaction — it *is* the Security role. This produces more consistent, deeper role-specific analysis than a sub-agent that receives role instructions as a one-shot prompt.
- *Message-based coordination.* Teammates communicate via `SendMessage`, enabling direct peer-to-peer coordination. A Developer teammate can message the Architect teammate to clarify an interface contract without routing through the PM. This is structurally different from sub-agents, which can only communicate with the PM and never with each other.
- *True parallel execution.* Multiple teammates execute simultaneously within a wave. This is genuine concurrency, not sequential delegation with parallel-sounding language.

The key trade-off is economic: token cost scales linearly with team size, so spawning five teammates for a CSS fix is wasteful. The inverted review default (lightweight review for most tasks, full review pipeline for sensitive changes) becomes an economic decision as well as a velocity one.

**Sub-agents via Task tool** (Tier 2 fallback) — The PM uses Claude Code's built-in Task tool to spawn sub-agents programmatically within a single session. Each sub-agent gets a fresh context window, does one task, and reports back. Sub-agents cannot communicate with each other — all coordination routes through the PM. They do not maintain persistent identity across interactions, and the PM must manually include relevant context in each delegation. This is simpler than Agent Teams and still automated, but it sacrifices parallel execution, peer coordination, and the automatic context loading that makes Agent Teams the stronger model.

**Manual session restarts** (Tier 3, last resort) — The PM closes the current session and starts fresh for each task. The PM re-reads state files at the start of each session. This is the most manual approach but works when the other options are unavailable.

### 3.3 Persistent State via Files

If each worker has a fresh context, how does the team maintain continuity? The answer is files. All state that needs to persist across sessions and workers is written to the filesystem:

**`.planning/STATE.md`** tracks the orchestrator's state: the current milestone, completed tasks, in-progress tasks, blocked tasks, wave plans, truth conditions, and key decisions. When the PM's context gets heavy or a new session begins, the PM reads this file to restore its working state. Nothing is lost because the source of truth is on disk, not in context. The file always starts with a "Current Status" section (no more than 20 lines) so the PM can scan it in seconds.

**`.planning/LEARNINGS.md`** accumulates team knowledge across iterations — an idea borrowed from the Ralph pattern's `AGENTS.md`. After each task, the executing agent appends any useful discoveries: patterns found in the codebase, gotchas encountered, conventions established, workarounds applied. Entries are tagged by category (`[ORM]`, `[AI]`, `[AUTH]`, etc.) for searchability. This file is included in every worker's context, so the team benefits from past experience.

**`.planning/DECISIONS.md`** logs settled questions. When the PM resolves a conflict, the human makes a key decision, or the team agrees to descope something, it gets logged here with the date, who decided, and the reasoning. This prevents relitigating settled questions across context resets — a common failure mode where a fresh session re-raises a question that was already answered three sessions ago, wasting both time and human attention.

**`CLAUDE.md`** is the project instruction file — the golden rules, tech stack, architecture summary, and team structure. It is the first thing every worker reads. It defines the invariants that all agents must respect regardless of what specific task they are working on.

These four files form the team's **institutional memory**. They replace the context window as the source of truth and enable the team to operate across arbitrarily many sessions without degradation. This persistence layer is especially critical under Agent Teams, where `/resume` and `/rewind` do not restore teammates — the files are the only continuity mechanism. Because Agent Teams teammates load CLAUDE.md automatically, the instruction file becomes the primary channel for transmitting project invariants to every teammate without explicit PM delegation. The other three files (STATE.md, LEARNINGS.md, DECISIONS.md) must be passed explicitly by the PM when spawning teammates, which reinforces the discipline of maintaining them accurately.

### 3.4 The PM Context Budget

The framework specifies that if the PM's context utilization exceeds approximately 60%, it should start a new session. The PM reads CLAUDE.md, STATE.md, LEARNINGS.md, and DECISIONS.md, and continues orchestrating from where it left off. This is a proactive measure — it prevents degradation rather than recovering from it. But the 60% threshold is the emergency backstop, not the primary strategy. The primary strategy is proactive context management through structured inputs, natural reset points, and externalized memory.

**Structured report-backs as input control.** The largest source of PM context bloat is verbose teammate reports. A developer teammate reporting back might include full code diffs, test output, implementation rationale, and debugging history — none of which the PM needs for orchestration. The framework mandates a compressed report format: status (pass/fail/blocked), a one-to-two sentence summary, list of files changed, test results (counts, not output), tagged learnings for the shared file, and blockers. This controls the single largest variable in PM context growth. The PM processes the structured report, updates state files, and moves to the next task. Implementation details stay in the teammate's context (which is discarded) and in the git history (which is permanent).

**Natural reset points over arbitrary thresholds.** Rather than relying solely on a utilization percentage (which is difficult to estimate precisely), the framework identifies natural points where a session reset is low-cost and high-value:

- Between milestones (always consider)
- Before verification waves (fresh attention for quality gates)
- After approximately three waves of multi-teammate execution
- When the PM cannot accurately recall the current milestone's truth conditions from context alone

These natural boundaries mean the PM resets proactively at points where the cost is minimal (wave boundary = no in-flight work) rather than reactively when degradation has already begun.

**The write-then-forget pattern.** After each wave, the PM writes results to STATE.md, learnings to LEARNINGS.md, and decisions to DECISIONS.md. The PM then treats the files — not its context — as the source of truth for previous waves. This is a form of externalized memory: the context window holds recent orchestration state, while the files hold the complete project history. The PM's context budget is spent on the current wave and the next wave, not on the entire project.

**Context budget estimation.** Before starting a milestone, the PM can estimate its context cost: number of waves multiplied by average teammates per wave gives the expected number of report-backs. Each structured report adds roughly 500-1000 tokens. A milestone with five waves averaging three teammates each generates approximately 15 report-backs — enough to warrant a mid-milestone reset. This estimation is approximate but useful for planning: it transforms context management from a reactive "am I at 60%?" check into a proactive "where should I plan my resets?" decision.

**The no-code rule.** The PM's context should contain task descriptions, file path references, pass/fail verdicts, and orchestration decisions — never source code, test output, or implementation details. When the PM needs to understand code (for review decisions, conflict resolution, or architecture verification), it delegates to a reviewer teammate who reports back with a verdict and summary. This is perhaps the most counterintuitive rule: the PM orchestrates the building of software it never reads directly. But the PM's value is in coordination, sequencing, and decision-making, not in code comprehension — and protecting the PM's context for those high-value activities is worth the delegation overhead.

In practice, these strategies mean the PM operates in a steady state of 30-40% context utilization, with resets at natural boundaries keeping it there. The 60% threshold becomes a safety net that rarely triggers rather than the primary management mechanism.

---

## 4. Task Design: Atomicity, Waves, and Truth Conditions

### 4.1 Atomic Task Sizing

For the fresh delegation model to work — whether the worker is an Agent Teams teammate or a sub-agent — each task must be small enough for a single worker to complete without context degradation. The framework defines "atomic" tasks with specific constraints:

- Each task should touch three or fewer logical units in its core change, where a unit is a set of cohesive files for one concern (for example, a route handler plus its migration plus its test). This prevents tasks from sprawling across unrelated parts of the codebase.
- The task description plus relevant source files plus CLAUDE.md should fit within 50% of the context window. If it doesn't, the task needs to be split.
- Each task does one thing: add an endpoint, write a migration, build a component. Compound tasks like "build the whole authentication system" must be decomposed.
- Each task must be independently testable. If you cannot write a test for a task in isolation, the task is too vague.

These constraints directly serve context management. A task that fits in 50% of context leaves the other 50% for the agent's reasoning, code generation, and test writing. A task that touches three or fewer files is small enough to hold entirely in working memory.

The anti-pattern is "Implement user authentication" as a single task. The correct decomposition is: create users table migration, add password hashing utility, build registration endpoint, build login endpoint, add JWT generation and validation, write auth middleware, write integration tests. Each of these is independently implementable, testable, and reviewable.

### 4.2 Wave-Based Execution

Within each milestone, the PM organizes tasks into **waves** based on their dependency relationships. A wave is a set of tasks that are independent of each other — they can be executed in any order (or in parallel) without conflicts. A wave starts only after the previous wave is fully complete.

This concept addresses three problems. First, it prevents dependency conflicts — a developer trying to build an API endpoint before the database schema exists. Second, it creates natural verification points — the end of each wave is an opportunity to run tests and verify that the foundation is solid before building on top of it. Third, and most importantly under Agent Teams, the wave structure prevents file-level write conflicts: because Agent Teams enables true parallel execution — multiple teammates working simultaneously, not sequentially — no two tasks in the same wave may modify the same file. Concurrent writes result in last-write-wins data loss. The PM must verify file independence when organizing waves, and when a wave contains multiple independent tasks, the PM must dispatch all teammates simultaneously rather than sequentially. Sequential dispatch of parallel-safe work wastes the primary advantage of Agent Teams.

The final wave of every milestone is always a verification wave: QA writes end-to-end tests and validates acceptance criteria; Security reviews the code merged during the milestone.

### 4.3 Goal-Backward Verification (Truth Conditions)

Traditional project management asks: "Did we complete all the tasks?" This is a necessary but insufficient check. All tasks can be marked done while the product is broken — tests might pass individually but the end-to-end workflow might fail; a feature might be implemented but unusable due to a UX issue; an edge case might crash the application.

The framework introduces **truth conditions**, borrowed from the GSD framework's goal-backward verification approach. Before starting a milestone, the PM defines a set of observable, testable statements that must be true when the milestone is complete:

- "A new user can register, verify email, and log in."
- "If the AI API is down, the user sees a graceful fallback message."
- "An unauthorized user cannot access the AI endpoint."
- "Tier 1 AI prompts have at least 5 eval test cases that pass (expected input produces expected output schema)."

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

**Phase 4: Development** — Execute wave by wave, milestone by milestone, using the delegation model (Agent Teams, sub-agents, or manual sessions). Cross-role review on every merge — lightweight by default (PM checks architecture and security in one pass), full 3-reviewer pipeline for sensitive changes (auth, AI, data models, API contracts). Milestone checkpoints with truth condition verification. Gate: PM verifies all milestones complete; each milestone requires human sign-off. An Integration Gate verifies all milestones work together end-to-end.

**Phase 5: Quality & Security Hardening** — Comprehensive security audit (including AI-specific risks), brainstorming session for edge cases, performance review. Gate: Human reviews security findings.

**Phase 6: Deployment & Launch Prep** — Production deployment scripts, domain and infrastructure setup, pre-launch checklist, demo script. Gate: Human approves for launch.

**Phase 7: Iteration & Backlog** — Retrospective, backlog grooming, continuous improvement. No gate — this is ongoing.

### 6.3 Gate Design Philosophy

Gates serve two purposes: quality assurance and human control. The framework assigns gates to either the human or the PM agent based on the type of decision involved.

**Human gates** are placed where the decision is *strategic*: approving the product spec (Phase 1), approving the architecture (Phase 2), approving the task plan (Phase 3), accepting the security posture (Phase 5), and authorizing deployment (Phase 6). These are decisions that require product judgment, risk assessment, or business context that the agent does not have.

**Agent (PM) gates** are placed where the check is *procedural*: verifying that all inputs are collected (Phase 0), validating that all milestones are complete (Phase 4). These are checklist verifications that the PM can perform autonomously.

**The Integration Gate** is a distinct gate type used after all milestones are individually complete. It verifies that the milestones work together end-to-end — catching integration issues that per-milestone checkpoints miss. Authentication working in isolation is different from authentication working with the AI service layer, which is different from both working under load.

The human can always override an agent gate — but the expectation is that they won't need to if the checklist is complete.

**Waiting at gates**: When the PM is blocked at a human gate, it may begin read-only preparation for the next phase (drafting the wave plan while waiting for architecture approval, outlining deployment steps while waiting for the hardening gate) but must not commit artifacts or begin implementation until the gate clears. Pre-work is logged in STATE.md so it is visible when the human returns. This prevents idle time without creating irreversible work.

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

- **Prompt injection** — malicious user input that manipulates the AI's behavior by injecting instructions into the prompt. The framework requires concrete defenses: delimiter tokens separating system instructions from user input, a classification step that screens user input before it reaches the main prompt, structured message formats that make injection boundaries clear, and output validation that rejects responses not matching the expected schema.
- **System prompt exposure** — the AI revealing its system prompt in response to crafted queries.
- **Data leakage** — the AI including sensitive data from other users' contexts in its responses.
- **Cost abuse** — a malicious user triggering expensive API calls at scale.
- **PII in prompts** — personal data being sent to third-party AI providers.

The framework requires the Security role to audit all AI integration points for these specific risks during Phase 5, using a severity classification (Critical and High block MVP launch; Medium and Low are logged for post-launch).

### 7.5 Structured Output and Caching

For Tier 1 features where the AI's output feeds into application logic (not just displayed to the user), the framework requires structured output handling: JSON mode or function calling to guarantee parseable responses, schema validation on every AI response before it enters the application, and typed interfaces that the rest of the codebase can rely on.

AI response caching is an architectural concern, not an optimization afterthought. The Architect identifies cacheable queries during Phase 2 (queries where the same input reliably produces an acceptable output), implements caching at the service layer, and defines TTL per use case. A recommendation engine might cache for hours; a real-time analysis endpoint might not cache at all. Cost estimation — approximate calls per user per day, cost per call, projected monthly spend — is part of the architecture review.

---

## 8. Tooling Augmentation

### 8.1 MCP Servers

Model Context Protocol (MCP) servers extend the agent's capabilities by providing structured access to external tools and services. The framework distinguishes between two categories:

**Development MCP servers** help the agent build faster — direct database access (Postgres MCP), programmatic issue management (GitHub MCP), file system tools. These augment the agent's development workflow.

**Product MCP servers** power features in the running application — browser automation, data connectors, third-party API integrations. These become part of the deployed product.

Each MCP server requires human approval before installation. The agent proposes it with a justification and a fallback approach, and the human approves or denies. This prevents the agent from installing tools that the human doesn't want in their environment.

### 8.2 Skills Acquisition

Skills are specialized instruction sets — markdown files containing best practices, patterns, and guidelines for specific technologies or tasks. Examples: "Next.js App Router patterns," "Playwright E2E best practices," "OpenAI streaming implementation."

The agent can propose downloading skill files that would improve its output quality for the specific project. Each proposal includes the source, what it covers, and why it's relevant. Approved skills are stored in the repository's `skills/` directory so they are versioned, visible, and available to all teammates and sub-agents.

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

Entries are tagged by category (`[ORM]`, `[AI]`, `[AUTH]`, `[TESTING]`, `[UI]`, `[INFRA]`, etc.) so workers can search for relevant learnings instead of reading the entire file. This file is included in every worker's context. Over time, it becomes a growing body of project-specific knowledge that prevents repeated mistakes and accelerates development.

The key insight from the Ralph community is that AI coding tools automatically read instruction files. By structuring learnings in a file that agents read at session start, the knowledge transfer is automatic — no human intervention required.

### 9.3 The Decision Log

A subtler form of knowledge loss is **decision loss** — the team re-raises a question that was already settled in a previous session. "Should we use Prisma or Drizzle?" was debated, decided, and logged in session 3. By session 8, a fresh context has no memory of that decision and escalates it to the human again. Multiply this across dozens of decisions and the human's time is consumed by relitigating rather than directing.

`.planning/DECISIONS.md` captures every significant decision: who made it, when, and the reasoning. The rule is simple: before raising a question to the human, check DECISIONS.md. If it has already been decided, execute the decision. If circumstances have changed and the decision should be revisited, reference the original entry when escalating so the human has full context.

---

## 10. Recovery & Pivot Protocol

### 10.1 When Assumptions Break

The playbook assumes forward progress, but sometimes a fundamental assumption turns out to be wrong mid-build. The database schema cannot support a key feature. The AI API's rate limits make the core workflow unviable. A critical third-party service does not work as expected. These are not bugs — they are design flaws that no amount of debugging will fix.

Without a defined recovery process, the team grinds against the broken assumption: retrying the same approach, generating increasingly convoluted workarounds, or silently descoping the feature. A pivot at milestone v0.2 is cheap. A pivot at v0.5 is expensive.

### 10.2 The Protocol

The framework defines explicit triggers and a structured process:

**Triggers**: A truth condition has failed three or more times with no viable fix path. A core technical assumption is proven wrong (not a bug — a design flaw). An external dependency becomes unavailable, too expensive, or too limited.

**Process**: The PM halts the current wave — no new tasks start. The PM writes a short pivot proposal covering what is broken, why it cannot be fixed within the current architecture, two to three alternative approaches with trade-offs, and a recommended path forward. The PM escalates to the human with the proposal. This is always a human decision. If approved, the PM updates ARCHITECTURE.md, logs the pivot in DECISIONS.md, re-plans affected milestones in STATE.md, and revises affected truth conditions. If denied, the human provides an alternative direction and the PM logs it.

The goal is to fail fast and pivot cleanly rather than accumulating technical debt against a broken foundation.

---

## 11. Post-MVP Evolution

### 11.1 The Ralph Loop Pattern

The Ralph Wiggum technique — named after the stubbornly persistent Simpsons character — is an autonomous iteration pattern where the agent runs in a loop: pick a task, execute it, verify the result, repeat. Each iteration starts with fresh context. The loop continues until all tasks are complete or a safety limit is reached.

The framework deliberately does not use this pattern during MVP development. The reasons:

1. Ralph is designed for autonomous execution with minimal human oversight. The framework prioritizes human governance at strategic points.
2. Ralph's verification is typically automated (tests pass or fail). The framework's multi-agent review via Agent Teams teammates (Architect, Security, QA) provides deeper validation.
3. Ralph works best for well-defined, low-risk tasks. MVP development involves ambiguous requirements and security-sensitive decisions.

However, the framework documents Ralph as a post-v1.0 tool for specific use cases: bug fix sprints (give it 20 well-defined bugs, let it work overnight), refactoring passes (convert all class components to functional components), and test coverage drives (write missing tests for all files in a directory). These are tasks with clear success criteria, low risk, and no product judgment required.

### 11.2 Autonomous Pipelines

Post-MVP, the framework supports automated agent-driven maintenance pipelines:

- **Nightly security scans** — spawn a Security teammate to run dependency audits and create issues for findings.
- **Weekly dependency updates** — spawn a Developer teammate to update packages, run tests, and open a PR if tests pass.
- **Documentation sync checks** — after merges to main, verify that docs match the code and create issues for drift.
- **AI cost monitoring** — daily checks on API usage against budget thresholds.

These pipelines rely on a mature test suite as their safety net. They are explicitly documented as future work — not part of the MVP build — to prevent premature automation.

---

## 12. Constructing a Playbook from These Principles

The principles described in this paper can be assembled into a concrete, executable playbook. Here is how:

### 12.1 Define Inputs

Start by listing everything the human must provide before work begins: the project idea, a repository, any API keys (AI providers, external services), and the production domain. Everything the agent needs to begin should be collected upfront to prevent interruptions during execution.

### 12.2 Write the Phase Structure

Organize the development lifecycle into sequential phases with explicit gates. Each phase should produce specific, named artifacts that feed into the next phase. Assign each gate to either the human (strategic decisions) or the PM agent (procedural checklists).

A recommended structure:

1. **Initialization** (agent gate) — inputs collected, repo scaffolded, folder structure created.
2. **Product Specification** (human gate) — comprehensive spec written through iterative dialogue, requirements extracted and numbered.
3. **Architecture & Technical Design** (human gate) — tech stack decided, data model designed, API contracts defined, AI architecture specified, instruction file written.
4. **Task Breakdown** (human gate) — milestones defined with truth conditions, issues created and sized atomically, waves planned.
5. **Development** (agent gate per milestone, human sign-off per milestone, integration gate across milestones) — wave-by-wave execution with fresh worker contexts and cross-role review.
6. **Quality & Security Hardening** (human gate) — comprehensive security audit, edge case brainstorming, AI-specific security review.
7. **Deployment** (human gate) — production scripts, domain setup, pre-launch checklist, demo.
8. **Iteration** (ongoing) — retrospective, backlog, continuous improvement.

### 12.3 Define the Team

List each role with its responsibilities, authority, and boundaries. Establish the conflict resolution hierarchy (PM resolves minor conflicts, human resolves major ones, Security overrides Developer by default). Create a phase ownership table mapping which role leads each phase.

### 12.4 Build the Instruction File Template

The project instruction file (CLAUDE.md or equivalent) is the agent's operating manual. It should include:

- Project overview (one-two sentences, link to spec).
- Team structure summary.
- Tech stack.
- Architecture summary (link to full architecture doc).
- Golden rules — 24 non-negotiable behaviors. Number them. Make them imperative. Examples:
  - "Test everything."
  - "Never break the build."
  - "All AI calls go through the service layer."
  - "Every AI feature has a fallback."
  - "Act like a senior team — make routine decisions, escalate product decisions."
  - "Fresh context for every task."
  - "Parallelize aggressively via Agent Teams." (When a wave has multiple independent tasks, dispatch all teammates simultaneously. Sequential execution of parallel-safe work is a process failure.)
  - "Truth conditions over task completion."
  - "Log learnings."
  - "Log decisions."

### 12.5 Define the Execution Model

Specify the delegation tier: Agent Teams (required default), sub-agents via Task tool (Tier 2 fallback), or manual session restarts (Tier 3, last resort). Then define how tasks move from "to do" to "done":

1. PM assigns task to a teammate (or sub-agent/fresh session in fallback mode) with role-specific instructions. Under Agent Teams, the teammate automatically loads CLAUDE.md and arrives with the project's conventions internalized.
2. Teammate creates a branch, implements, tests, commits.
3. Teammate reports results via files (commit, LEARNINGS.md update, structured summary) and via `SendMessage` to the PM.
4. Review: lightweight by default (PM checks architecture + security in one pass), full pipeline for sensitive changes (separate Architect, Security, QA teammates).
5. If changes requested, a new teammate gets the feedback and fixes.
6. Review passes, PM merges, STATE.md updated.

Define wave rules: independent tasks in the same wave, no two tasks in the same wave modify the same file, waves execute sequentially, final wave is verification.

Define context management rules: PM stays under 60% context, workers get only what they need (task, CLAUDE.md, relevant ARCHITECTURE.md section, LEARNINGS.md, DECISIONS.md), state persists in files.

### 12.6 Define the Autonomy Boundary

Be explicit about what the team decides independently and what requires human consultation. Write both lists. The "do not stop for" list is as important as the "must stop for" list — it gives the agent confidence to act.

Use the senior engineer heuristic: if they would just do it, the agent should just do it. If they would ask the product owner, the agent should ask.

### 12.7 Add AI Integration Patterns (If Applicable)

If the product includes AI features, define:

- The tier model (core logic, suggestions, chatbot).
- The AI service layer pattern.
- Model selection per tier.
- Prompt management approach (prompts as code, versioned, reviewed).
- Structured output handling for Tier 1 features (JSON mode, function calling, schema validation).
- Fallback strategy for every AI feature.
- Cost estimation (approximate calls per user per day, cost per call, projected monthly spend).
- AI response caching strategy (cacheable queries, TTL per use case).
- Prompt evaluation baseline (at least 5 test cases per Tier 1 prompt during development, expanded post-MVP).
- AI-specific security audit checklist (prompt injection defenses, system prompt exposure, data leakage, cost abuse, PII handling).

### 12.8 Add Protocols for External Dependencies

Define how the team handles new services (Service Keys Protocol), new tools (MCP Server and Skills Acquisition), and new dependencies (standard libraries are fine, unusual dependencies require justification).

### 12.9 Add Appendices

Include reference material that the team will need repeatedly:

- File reference (every file the playbook produces, its purpose, when it's created).
- Labeling taxonomy for issues (feature, bug, security, testing, documentation, infrastructure, ai).
- Commit message conventions.
- Future automation opportunities (post-MVP).

### 12.10 Review and Trim

Go through the entire playbook and apply the design principle from Section 1.3: every practice must trace to a specific failure mode. If a section exists because "good engineering practice" but does not address context rot, specification drift, security blindness, decision creep, or knowledge loss, consider removing it. The playbook should be as short as possible while preventing every failure mode it targets.

---

## 13. Conclusion

The framework described in this paper is not about making AI agents follow a process. It is about designing the right constraints so that AI agents produce reliable, secure, production-quality software while maintaining human control over product direction.

The key ideas are:

1. **Roles create adversarial review.** A single agent reviewing its own work is theater. Agent Teams teammates — each with independent context, persistent identity, and automatic CLAUDE.md loading — create genuine evaluation from structurally separate perspectives. Sub-agents offer a weaker form of the same principle when Agent Teams is unavailable.

2. **Fresh context prevents rot.** The orchestrator stays light; workers get clean context. State lives in files, not in conversation history. Agent Teams is the primary mechanism (independent context windows with true parallel execution), with sub-agents via the Task tool and manual session restarts as fallback tiers.

3. **Parallelization is mandatory, not optional.** When a wave contains multiple independent tasks, the PM must dispatch all teammates simultaneously. Agent Teams exists to enable true concurrent execution — using it for sequential dispatch squanders its primary advantage. The wave structure and file-independence checks exist specifically to make aggressive parallelization safe.

4. **Truth conditions prevent false completion.** Checking tasks off a list does not guarantee the product works. Testing observable outcomes does.

5. **Autonomy needs explicit boundaries.** Define what the team decides independently *and* what requires human input. Both lists are essential.

6. **Knowledge must persist.** Learnings files give the team institutional memory across sessions. Decision logs prevent relitigating settled questions. The team gets smarter over time instead of starting from zero.

7. **Security must be structurally privileged.** Without an explicit override hierarchy, the agent's bias toward shipping will override security concerns. Make security the default winner.

8. **Recovery must be defined before it's needed.** When a fundamental assumption breaks, the team needs a protocol — halt, propose alternatives, escalate to the human — not ad hoc improvisation.

9. **Every practice must earn its place.** If a process element doesn't prevent a specific, named failure mode, it is overhead. Remove it.

These principles are rooted in Claude Code's Agent Teams as the primary execution model, but the underlying concepts are portable. Agent Teams is preferred because it provides the strongest structural enforcement of the framework's core principles — independent contexts, persistent role identity, parallel execution, and message-based coordination. Sub-agents via the Task tool offer a viable fallback that preserves fresh context isolation while sacrificing parallelism and peer coordination. The broader concepts — role separation, context management, truth conditions, autonomy boundaries — apply to any AI coding agent that supports autonomous execution, task delegation, and file-based state management. The specific implementation details (CLAUDE.md vs. AGENTS.md, GitHub Issues vs. Linear, Next.js vs. other stacks) are interchangeable. The architecture of the process is what matters.

The goal is not to replace human judgment with AI process. It is to free human judgment for the decisions that actually require it — product vision, risk tolerance, user experience — while letting a well-structured AI team handle everything else.

---

## References & Influences

- **GSD (Get Shit Done) Framework** — by TÂCHES (glittercowboy). Open-source meta-prompting and context engineering system for Claude Code. Key contributions to this framework: fresh sub-agent contexts, aggressive atomicity, wave-based execution, goal-backward verification. GitHub: `glittercowboy/get-shit-done`

- **Ralph Wiggum Technique** — by Geoffrey Huntley. Autonomous iteration pattern for AI coding agents. Key contribution: the concept of a bash loop that runs agents repeatedly with fresh context until verification passes, and the learnings file pattern for persistent knowledge. GitHub: `ghuntley/how-to-ralph-wiggum`

- **Claude Code Agent Teams** — by Anthropic. Native multi-agent orchestration feature for Claude Code (research preview). Key contribution: first-class support for parallel teammate execution with independent context windows, shared task management, and inter-agent messaging. Enables the delegation model described in this paper to run on real infrastructure rather than manual session management. Source: `code.claude.com/docs/en/agent-teams`

- **Claude Code Best Practices** — by Anthropic. Official guidance on using Claude Code effectively, including headless mode, task management, and CLAUDE.md conventions. Source: `docs.anthropic.com`

---

*This paper documents the design rationale for the App Builder Playbook, a structured framework for building production-ready AI-powered applications using autonomous AI coding agent teams.*
