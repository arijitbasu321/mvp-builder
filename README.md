# App Builder Playbook

A structured playbook for building production-ready, AI-powered applications using Claude Code's Agent Teams. You provide the idea. The PM builds the product.

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed
- GitHub repo and project board created
- Your project idea, target users, and production domain
- AI API key (OpenAI, Anthropic, xAI, Google, or other provider)

## Setup

1. Enable Agent Teams in your Claude Code settings:

```json
{
  "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": 1
}
```

2. Copy the `.claude/commands/` directory into your project root. This gives you the slash commands below.

3. Copy `APP_BUILDER_PLAYBOOK_3.md` into your project root for reference (the commands extract what they need from it, but having the full playbook available is useful for edge cases).

## Quick Start

```bash
claude --dangerously-skip-permissions
```

Then:

```
/start-mvpb

Project Name: MyApp
Idea: A meal planning app that generates weekly grocery lists using AI
Target Users: Busy professionals who want to eat healthier
Domain: myapp.com
```

The PM takes over from there.

## Commands

The playbook is broken into slash commands — one per phase, plus utilities. Each command gives Claude exactly the context it needs for that phase.

### Phase Commands

| Command | Phase | What It Does |
|---------|-------|-------------|
| `/start-mvpb` | 0 — Init | Collects inputs, scaffolds repo, creates project board |
| `/spec-mvpb` | 1 — Spec | Writes the product specification through iterative dialogue |
| `/architect-mvpb` | 2 — Architecture | Designs tech stack, data model, API, AI architecture |
| `/plan-mvpb` | 3 — Planning | Breaks requirements into milestones, issues, waves |
| `/build-mvpb` | 4 — Development | Builds the app milestone by milestone |
| `/harden-mvpb` | 5 — Hardening | Security audit, quality review, bug fixes |
| `/deploy-mvpb` | 6 — Deployment | Production deployment, monitoring, demo script |
| `/iterate-mvpb` | 7 — Iteration | Post-MVP improvements and backlog |

### Utility Commands

| Command | What It Does |
|---------|-------------|
| `/status-mvpb` | Quick status report — current phase, milestone, wave, blockers |
| `/resume-mvpb` | Reloads all state files and picks up where the last session left off |
| `/pivot-mvpb` | Invokes the recovery protocol when something fundamental breaks |

### Typical Flow

```
/start-mvpb     → scaffolds everything, asks for inputs
/spec-mvpb      → iterative spec writing with human review
/architect-mvpb → tech stack, data model, API design, AI architecture
/plan-mvpb      → milestones, issues, wave plans
/build-mvpb     → development loop (run this repeatedly — it reads STATE.md each time)
/status-mvpb    → check progress anytime
/resume-mvpb    → after a break or context reset
/harden-mvpb    → security audit after all milestones complete
/deploy-mvpb    → production deployment and launch
/iterate-mvpb   → post-MVP improvements
```

## Your Job During the Build

You have 5 human gates where the PM will stop and wait for your sign-off:

| Gate | Phase | What You're Approving |
|------|-------|-----------------------|
| 1 | Product Spec | What the product does |
| 2 | Architecture | How it's built |
| 3 | Task Plan | The build order |
| 4 | Hardening | Security audit and quality review |
| 5 | Deployment | Production launch readiness |

Between gates: provide API keys when requested, make decisions when escalated, otherwise stay out of the way.

## How It Works

The playbook defines 6 roles (PM, Architect, Developer, QA, Security, DevOps) that operate as an autonomous team:

| Mode | How It Works | Best For |
|------|-------------|----------|
| **Agent Teams** (preferred) | Native Claude Code feature — PM spawns teammates with independent context windows | Full parallel execution |
| **Task tool** (fallback) | PM spawns sub-agents programmatically within one session | Simpler, still automated |
| **Manual sessions** (last resort) | Fresh `claude` session per task, PM manages state via files | When other modes unavailable |

## Key Files

| File | Purpose |
|------|---------|
| `APP_BUILDER_PLAYBOOK_3.md` | The full playbook reference |
| `.claude/commands/*.md` | Slash commands (this is what you actually use) |
| `CLAUDE.md` | Generated in Phase 2 — agent reads this every session |
| `.planning/STATE.md` | Current progress, waves, truth conditions |
| `.planning/DECISIONS.md` | Settled decisions — prevents relitigating |
| `.planning/LEARNINGS.md` | Team knowledge that accumulates across tasks |

## License

[Your license here]
