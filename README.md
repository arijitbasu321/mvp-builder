# App Builder Playbook

A structured playbook for building production-ready, AI-powered applications using Claude Code's Agent Teams. You provide the idea. The PM builds the product.

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed
- GitHub repo and project board created
- Your project idea, target users, and production domain
- AI API key (OpenAI or equivalent)

## Setup

Enable Agent Teams in your Claude Code settings:

```json
{
  "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": 1
}
```

## Quick Start

**1. Launch Claude Code:**

```bash
claude --dangerously-skip-permissions
```

**2. Hand it the playbook:**

```
Read APP_BUILDER_PLAYBOOK_3.md. You are the PM. Here's the project:

Name: [your project name]
Idea: [1-3 sentences]
Repo: [github.com/you/repo]
Target users: [who is this for]
Domain: [production domain]
AI API key: [your key]
```

**3. Let it run.** The PM takes over — follows the 7 phases, delegates to the team, and checks in with you at each gate.

## Your Job During the Build

You have 5 human gates where the PM will stop and wait for your sign-off:

| Gate | Phase | What You're Approving |
|------|-------|-----------------------|
| 1 | Product Spec | What the product does |
| 2 | Architecture | How it's built |
| 3 | Task Plan | The build order (milestones, waves, truth conditions) |
| 4 | Hardening | Security audit and quality review |
| 5 | Deployment | Production launch readiness |

Between gates, your job is:
- Provide API keys when the PM requests them
- Make decisions when the PM escalates conflicts or pivots
- Otherwise, stay out of the way

## Resuming After a Break

If a session ends, context degrades, or you come back after time away:

```
Read CLAUDE.md, .planning/STATE.md, .planning/DECISIONS.md, .planning/LEARNINGS.md.
You are the PM. Resume where we left off.
```

All state lives in files — nothing is lost between sessions.

## How It Works

The playbook defines 6 roles (PM, Architect, Developer, QA, Security, DevOps) that operate as an autonomous team. The PM orchestrates via three possible execution modes:

| Mode | How It Works | Best For |
|------|-------------|----------|
| **Agent Teams** (preferred) | Native Claude Code feature — PM spawns teammates with independent context windows | Full parallel execution |
| **Task tool** (fallback) | PM spawns sub-agents programmatically within one session | Simpler, still automated |
| **Manual sessions** (last resort) | Fresh `claude` session per task, PM manages state via files | When other modes unavailable |

## Key Files

| File | Purpose |
|------|---------|
| `APP_BUILDER_PLAYBOOK_3.md` | The full playbook — hand this to Claude Code |
| `CLAUDE.md` | Generated in Phase 2 — agent reads this every session |
| `.planning/STATE.md` | Current progress, waves, truth conditions |
| `.planning/DECISIONS.md` | Settled decisions — prevents relitigating |
| `.planning/LEARNINGS.md` | Team knowledge that accumulates across tasks |

## License

[Your license here]
