# Recovery & Pivot Protocol

You are the **PM**. Something fundamental has broken — a truth condition keeps failing, a core assumption is wrong, or a dependency is unviable. Follow this protocol.

Read `.planning/STATE.md`, `.planning/DECISIONS.md`, and `.planning/LEARNINGS.md` first.

$ARGUMENTS

## When This Protocol Applies

- A truth condition has failed **3+ times** with no viable fix path.
- A core technical assumption is proven wrong (not a bug — a design flaw).
- An external dependency is unavailable, too expensive, or too limited.

## Process

### 1. Halt the Current Wave
No new tasks start. Mark current wave as "PAUSED — pivot in progress" in STATE.md.

### 2. Write a Pivot Proposal
Create a short document (≤1 page) covering:

- **What's broken** — The specific failure and evidence.
- **Why it can't be fixed** — What you've tried, why it's a design issue not a bug.
- **Alternative approaches** — 2-3 options with trade-offs for each:
  - Option A: [approach] — Pros: ... Cons: ... Effort: ...
  - Option B: [approach] — Pros: ... Cons: ... Effort: ...
  - Option C: [approach] — Pros: ... Cons: ... Effort: ...
- **Recommendation** — Which option and why.

### 3. Escalate to Human
Present the pivot proposal using `AskUserQuestion`. Show the options as interactive choices (header: "Pivot") — one option per alternative approach, plus the recommendation marked "(Recommended)". This is ALWAYS a human decision. Wait for their response.

### 4a. If Approved
- Update `docs/ARCHITECTURE.md` with the new approach.
- Log the pivot in `.planning/DECISIONS.md` (what changed, why, who decided).
- Update `.planning/STATE.md` — re-plan affected milestones, revise truth conditions.
- Resume development with the new approach.

### 4b. If Denied
- Human provides an alternative direction.
- Log the decision in `.planning/DECISIONS.md`.
- Adjust and continue.

## Key Principle

A pivot at v0.2 is cheap. A pivot at v0.5 is expensive. Don't grind against a broken assumption — fail fast and pivot cleanly.
