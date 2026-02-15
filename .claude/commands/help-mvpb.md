# MVP Builder — Help

Display this banner exactly as-is (do NOT use the Bash tool — just output it directly as text):

```
  ███╗   ███╗██╗   ██╗██████╗
  ████╗ ████║██║   ██║██╔══██╗
  ██╔████╔██║██║   ██║██████╔╝
  ██║╚██╔╝██║╚██╗ ██╔╝██╔═══╝
  ██║ ╚═╝ ██║ ╚████╔╝ ██║
  ╚═╝     ╚═╝  ╚═══╝  ╚═╝
  ██████╗ ██╗   ██╗██╗██╗     ██████╗ ███████╗██████╗
  ██╔══██╗██║   ██║██║██║     ██╔══██╗██╔════╝██╔══██╗
  ██████╔╝██║   ██║██║██║     ██║  ██║█████╗  ██████╔╝
  ██╔══██╗██║   ██║██║██║     ██║  ██║██╔══╝  ██╔══██╗
  ██████╔╝╚██████╔╝██║███████╗██████╔╝███████╗██║  ██║
  ╚═════╝  ╚═════╝ ╚═╝╚══════╝╚═════╝ ╚══════╝╚═╝  ╚═╝
```

Then display ONLY the reference content below. Do NOT add project-specific analysis, git status, or commentary.

<reference>

**Idea → Spec → Architecture → Code → Ship.** One command at a time.

---

## Commands

**Phase Commands:**
- `/start-mvpb` — Phase 0: Collect inputs, scaffold repo, create project board
- `/spec-mvpb` — Phase 1: Write the product spec through iterative dialogue
- `/architect-mvpb` — Phase 2: Design tech stack, data model, API, AI architecture
- `/plan-mvpb` — Phase 3: Break requirements into milestones, issues, waves
- `/build-mvpb` — Phase 4: Build the app milestone by milestone
- `/harden-mvpb` — Phase 5: Security audit, quality review, bug fixes
- `/sweep-mvpb` — Phase 6: Final code sweep by Architect + Developers
- `/deploy-mvpb` — Phase 7: Production deployment, monitoring, demo script
- `/iterate-mvpb` — Phase 8: Post-MVP improvements and backlog

**Utility Commands:**
- `/status-mvpb` — Quick status: phase, milestone, wave, blockers
- `/resume-mvpb` — Reload all state files, pick up where you left off
- `/pivot-mvpb` — Recovery protocol when something fundamental breaks
- `/help-mvpb` — This reference

---

## Quick Start

```
/start-mvpb             ← scaffold project, collect inputs
/spec-mvpb              ← write product spec (human approves)
/architect-mvpb         ← design architecture (human approves)
/plan-mvpb              ← create milestones + waves (human approves)
/build-mvpb             ← develop (repeat until done)
/harden-mvpb            ← security audit (human approves)
/sweep-mvpb             ← builders' final review (human approves)
/deploy-mvpb            ← ship it (human approves)
```

## Your Job

6 human gates. Between them, provide API keys when asked and make decisions when escalated. Otherwise, stay out of the way.

- After `/spec` — What the product does
- After `/architect` — How it's built
- After `/plan` — The build order
- After `/harden` — Security posture
- After `/sweep` — Code quality and integration
- After `/deploy` — Launch readiness

## Key Files

```
.planning/
├── STATE.md              # Where we are (milestones, waves, progress)
├── DECISIONS.md          # Settled questions — don't relitigate
├── LEARNINGS.md          # Team knowledge — patterns, gotchas
docs/
├── PRODUCT_SPEC.md       # What we're building
├── ARCHITECTURE.md       # How we're building it
├── DEMO.md               # How to show it off
CLAUDE.md                 # Golden rules — every session reads this
```

## Execution Modes

- **Agent Teams** (preferred) — `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` — parallel teammates
- **Task tool** (fallback) — Sub-agents within one session
- **Manual sessions** (last resort) — Fresh `claude` per task

## If Things Break

`/pivot-mvpb` — Halts work, writes a proposal with alternatives, escalates to you. A pivot at v0.2 is cheap. A pivot at v0.5 is expensive.

## After MVP Ships

`/iterate-mvpb` — Retrospective, backlog review, continuous improvement. Same engine, smarter team (LEARNINGS.md carries forward).

---

*Built on principles from GSD, Ralph Wiggum, and Claude Code Agent Teams.*
*Full playbook: APP_BUILDER_PLAYBOOK_3.md | Design rationale: WHITEPAPER.md*

</reference>
