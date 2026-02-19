# Resume From Where We Left Off

You are the **PM**. A previous session ended (context expired, break taken, or fresh start). Reload all state and continue.

## State Recovery

Read these files in this exact order:

1. **`CLAUDE.md`** — Golden rules, tech stack, team structure. This is your operating manual.
2. **`.planning/STATE.md`** — Current phase, milestone, wave, truth conditions, progress. Start with the "Current Status" section at the top.
3. **`.planning/DECISIONS.md`** — Settled questions. Do not relitigate these.
4. **`.planning/LEARNINGS.md`** — Team knowledge. Patterns, gotchas, conventions.

Then check:
5. **`docs/PRODUCT_SPEC.md`** — Does it exist? Is it approved?
6. **`docs/ARCHITECTURE.md`** — Does it exist? Is it approved?
7. **Git log** (`git log --oneline -20`) — What was the last work done?
8. **GitHub Issues** — What's in progress? What's blocked?

$ARGUMENTS

## After Loading State

1. Report where things stand (use the `/status` format).
2. Identify the next action based on STATE.md.
3. If mid-phase, pick up where the last session left off.
4. If at a gate, check if it's been approved. If not, present the gate checklist to the human.
5. If the human provides direction, follow it. Otherwise, continue the current phase.

## Key Rule

All state lives in files. Nothing is lost between sessions. Trust the files — they are the source of truth, not your memory of previous conversations.

## ➡️ Auto-Continue

After loading state and reporting status, **immediately resume the current phase** by reading and executing the appropriate command file:

| Phase | Command File |
|-------|-------------|
| 0 — Init | `.claude/commands/start-mvpb.md` |
| 1 — Spec | `.claude/commands/spec-mvpb.md` |
| 2 — Architecture | `.claude/commands/architect-mvpb.md` |
| 3 — Planning | `.claude/commands/plan-mvpb.md` |
| 4 — Development | `.claude/commands/build-mvpb.md` |
| 5 — Hardening | `.claude/commands/harden-mvpb.md` |
| 6 — Final Code Sweep | `.claude/commands/sweep-mvpb.md` |
| 7 — Playwright Acceptance Loop | `.claude/commands/accept-mvpb.md` |
| 8 — Deployment | `.claude/commands/deploy-mvpb.md` |
| 9 — Iteration | `.claude/commands/iterate-mvpb.md` |

**Exception**: If the current phase is sitting at an unapproved 🧑 Human gate, **STOP** and present the gate checklist to the human instead of resuming execution. Only continue after the human approves.
