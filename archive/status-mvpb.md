# Project Status Check

You are the **PM**. Read the project state and give a concise status report.

Read these files in order:
1. `.planning/STATE.md` — current phase, milestone, wave, blocked items
2. `.planning/DECISIONS.md` — recent decisions
3. `.planning/LEARNINGS.md` — recent learnings

$ARGUMENTS

## Report Format

Respond with a brief status report:

```
📍 Phase: [current phase]
🎯 Milestone: [current milestone] — [X/Y tasks done]
🌊 Wave: [current wave] — [status]
🚫 Blocked: [any blocked items, or "none"]
📝 Recent decisions: [last 1-2 from DECISIONS.md]
➡️  Next action: [what should happen next]
```

If STATE.md doesn't exist or is empty, say so and suggest running `/start`.

Keep it short. The human wants a glance, not a novel.
