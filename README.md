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

2. Clone this repo and run `setup.sh` to bootstrap your project:

```bash
git clone https://github.com/arijitbasu321/mvp-builder.git
cd mvp-builder

# Basic — copy toolkit into your project repo
./setup.sh /path/to/your-project

# With pre-existing user stories/epics file
./setup.sh /path/to/your-project epics.md
```

This copies the slash commands, settings, and playbook into your project. After setup, you work entirely from your project repo.

## Quick Start

```bash
cd /path/to/your-project
claude --dangerously-skip-permissions
```

Then:

```
/start-mvpb
```

The PM takes over from there — it will ask for your project name, idea, target users, AI provider, and hosting preferences interactively.

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
| `/sweep-mvpb` | 6 — Code Sweep | Architect + Developer full codebase review for bugs |
| `/deploy-mvpb` | 7 — Deployment | Production deployment, monitoring, demo script |
| `/iterate-mvpb` | 8 — Iteration | Post-MVP improvements and backlog |

### Utility Commands

| Command | What It Does |
|---------|-------------|
| `/status-mvpb` | Quick status report — current phase, milestone, wave, blockers |
| `/resume-mvpb` | Reloads all state files and picks up where the last session left off |
| `/pivot-mvpb` | Invokes the recovery protocol when something fundamental breaks |
| `/help-mvpb` | Overview of all commands, phases, and gates |

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
/sweep-mvpb     → architect + developer full codebase review
/deploy-mvpb    → production deployment and launch
/iterate-mvpb   → post-MVP improvements
```

## Your Job During the Build

You have 6 human gates where the PM will stop and wait for your sign-off:

| Gate | Phase | What You're Approving |
|------|-------|-----------------------|
| 1 | Product Spec | What the product does |
| 2 | Architecture | How it's built |
| 3 | Task Plan | The build order |
| 4 | Hardening | Security audit and quality review |
| 5 | Code Sweep | Builders' final review — bugs, integration seams, drift |
| 6 | Deployment | Production launch readiness |

During Phase 4 (Development), each milestone also requires your sign-off before the next one begins. Between gates: provide API keys when requested, make decisions when escalated, otherwise stay out of the way.

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
| `.planning/LEARNINGS_ARCHIVE.md` | Archived learnings from older milestones |

## License

[Your license here]
