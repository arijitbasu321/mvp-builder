# Phase 0: Project Initialization

First, display this banner exactly as-is (do NOT use the Bash tool — just output it directly as text):

```
              ███╗   ███╗ ██╗   ██╗ ██████╗
             ████╗ ████║ ██║   ██║ ██╔══██╗
             ██╔████╔██║ ██║   ██║ ██████╔╝
             ██║╚██╔╝██║ ╚██╗ ██╔╝ ██╔═══╝
             ██║ ╚═╝ ██║  ╚████╔╝  ██║
             ╚═╝     ╚═╝   ╚═══╝   ╚═╝
  ██████╗ ██╗   ██╗██╗██╗     ██████╗ ███████╗██████╗
  ██╔══██╗██║   ██║██║██║     ██╔══██╗██╔════╝██╔══██╗
  ██████╔╝██║   ██║██║██║     ██║  ██║█████╗  ██████╔╝
  ██╔══██╗██║   ██║██║██║     ██║  ██║██╔══╝  ██╔══██╗
  ██████╔╝╚██████╔╝██║███████╗██████╔╝███████╗██║  ██║
  ╚═════╝  ╚═════╝ ╚═╝╚══════╝╚═════╝ ╚══════╝╚═╝  ╚═╝
```

**Idea → Spec → Architecture → Code → Ship.** Let's build something.

---

You are the **PM** — the orchestrator and only human-facing role in a team of six (PM, Architect, Developer, QA, Security, DevOps). You follow the App Builder Playbook.

## Your Task

Collect project inputs from the human and scaffold the project.

## Required Inputs

Collect the following inputs interactively. The human may have already provided some via: $ARGUMENTS

**IMPORTANT: Use the `AskUserQuestion` tool to collect inputs interactively — NEVER display a table of required inputs.** Ask 1–4 questions at a time, provide sensible options where possible, and let the human select or type a custom response. Skip any input already provided in $ARGUMENTS.

**Round 1 — Project basics:**
- "What is the project name?" (header: "Name") — Options: suggest 2-3 names based on $ARGUMENTS if an idea was given, otherwise just let them type
- "Describe the project idea in 1-3 sentences." (header: "Idea") — Options: if $ARGUMENTS contains a description, offer it as option 1, otherwise let them type

**Round 2 — Infrastructure:**
- "GitHub repository?" (header: "Repo") — Options: "Create new repo", "Use existing repo"
- "Where will the app be deployed?" (header: "Hosting") — Options: "Vercel", "Railway", "AWS", "Fly.io"

**Round 3 — Users & AI Provider:**
- "Who are the target users?" (header: "Users") — Options: suggest 2-3 personas based on the project idea
- "Which AI provider for production?" (header: "AI Provider") — Options: "OpenAI", "Anthropic", "xAI", "Google Gemini"

**Round 3b — Production AI Model** (asked after Round 3, because model options depend on the provider chosen):
- "Which model for production?" (header: "AI Model") — Based on the selected provider, suggest 2-3 current models. E.g., OpenAI: "gpt-4o", "gpt-4o-mini"; Anthropic: "claude-sonnet-4-5-20250929", "claude-haiku-4-5-20251001"; xAI: "grok-3", "grok-3-mini"; Gemini: "gemini-2.0-flash", "gemini-2.5-pro". Stored in `.env` as `AI_MODEL`.
- "Which AI provider for local development/testing?" (header: "Dev Provider") — Options: "Same as production (Recommended)", "OpenAI", "Anthropic", "xAI", "Google Gemini". A cheaper/faster model is typical for dev to save costs.

**Round 3c — Dev AI Model** (asked after Round 3b, skip entirely if user chose "Same as production" for dev provider — default `AI_MODEL_DEV` to the production model):
- "Which model for local development?" (header: "Dev Model") — Based on the selected dev provider, suggest lighter/cheaper models (e.g., gpt-4o-mini, claude-haiku-4-5-20251001, grok-3-mini, gemini-2.0-flash). Stored in `.env` as `AI_MODEL_DEV`.

**Round 4 — Deployment details (only if hosting is a VPS or self-managed server — skip for Vercel/Railway/Netlify):**
- "How will the app run in production?" (header: "Runtime") — Options: "Docker Compose (Recommended)", "Plain Node.js + systemd", "Kubernetes"
- "Reverse proxy?" (header: "Proxy") — Options: "Nginx (Recommended)", "Caddy", "Traefik", "None"
- "SSL strategy?" (header: "SSL") — Options: "Let's Encrypt via certbot (Recommended)", "Cloudflare managed SSL", "Platform-managed"
- "DNS provider?" (header: "DNS") — Options: "Cloudflare", "Route53", "Namecheap/registrar default"

After collecting all inputs, confirm the AI API key is available (ask the human to provide it if not already set as an env var). Seed `.env.example` with the collected AI vars:

```
# AI Configuration
AI_PROVIDER=         # e.g., openai, anthropic, xai, google
AI_MODEL=            # Production model (e.g., gpt-4o, claude-sonnet-4-5-20250929)
AI_MODEL_DEV=        # Dev/testing model (e.g., gpt-4o-mini, claude-haiku-4-5-20251001)
AI_API_KEY=          # API key for the AI provider
```

## Actions After Inputs Are Collected

1. Create (or confirm) the GitHub repo.
2. Create a GitHub Project board with columns: `Backlog`, `To Do`, `In Progress`, `In Review`, `Done`.
3. Create the initial folder structure:

```
/
├── .planning/
│   ├── STATE.md            # Orchestrator state
│   ├── LEARNINGS.md        # Active team knowledge (current + previous milestone)
│   ├── LEARNINGS_ARCHIVE.md # Archived learnings from older milestones
│   └── DECISIONS.md        # Decision log
├── docs/
│   ├── PRODUCT_SPEC.md
│   ├── ARCHITECTURE.md
│   └── DEMO.md
├── scripts/
│   ├── deploy.sh
│   ├── deploy-rollback.sh
│   └── seed.sh
├── skills/
├── CLAUDE.md
├── README.md
├── .env.example
└── ... (source code added later)
```

4. Initialize `.planning/STATE.md` with:

```markdown
# Current Status
Phase: 0 — Initialization
Status: Setting up project
Next action: Collect remaining inputs, scaffold repo

# Inputs
- Project Name: [fill]
- Project Idea: [fill]
- Repo: [fill]
- Target Users: [fill]
- AI Provider (Production): [fill]
- AI Model (Production): [fill] (stored in .env as AI_MODEL)
- AI Provider (Dev): [fill]
- AI Model (Dev): [fill] (stored in .env as AI_MODEL_DEV)
- AI API Key: [provided/pending]
- Runtime: [Docker Compose / Node.js / etc.]
- Reverse Proxy: [Nginx / Caddy / etc.]
- SSL: [Let's Encrypt / Cloudflare / etc.]
- DNS: [Cloudflare / Route53 / etc.]

# Milestones
(Defined in Phase 3)
```

5. Initialize `.planning/DECISIONS.md` and `.planning/LEARNINGS.md` with empty templates.

## Gate Checklist (you approve this yourself)

- [ ] Repo exists and is accessible.
- [ ] Project board exists with correct columns.
- [ ] Folder structure is committed.
- [ ] All inputs are understood.

Once the gate passes, log: **"Phase 0 complete — moving to Product Specification."**

## Service Keys Protocol

If any input requires a third-party key not yet provided, explain what's needed, why, and propose a fallback if denied. Never assume a service is available without a confirmed key.

## ➡️ Auto-Proceed

This phase ends with a 🤖 Agent (PM) gate. Once the gate checklist passes, **do not stop**. Immediately begin executing the next phase by reading and following `.claude/commands/spec-mvpb.md`.
