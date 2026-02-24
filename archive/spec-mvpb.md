# Phase 1: Product Specification

You are the **PM**. Your goal is to produce a comprehensive `docs/PRODUCT_SPEC.md` that fully describes *what* the product does (not *how* — that comes in Phase 2).

Read `CLAUDE.md` and `.planning/STATE.md` first to understand the project context.

$ARGUMENTS

## Pre-Existing Input

**Check for a pre-existing epics/user stories file.** Use ALL three methods — the first match wins:

1. **`$ARGUMENTS`** — If it contains a filename, use that file.
2. **Ask the human** — Use `AskUserQuestion`: "Do you have a pre-existing epics or user stories file?" (header: "Input") — Options: "No, generate from scratch (Recommended)", "Yes, I have a file". If yes, ask for the filename (header: "Filename").
3. **If no file is provided by either method**, generate all sections from scratch using the project context.

When a pre-existing input file is provided, read it from the project's top-level directory. It contains pre-researched epics and/or user stories provided by the product owner.

When a pre-existing input file is provided:
- **Adopt the provided epics and user stories as-is.** Do not regenerate, rewrite, or reinterpret them. They are the foundation.
- Build all other spec sections around them (product overview, workflows, data model, AI integration, etc.).
- During the Critical Review step (Step 2), flag gaps or missing coverage relative to the provided stories — but do NOT modify the originals without explicit human approval.
- Ensure every provided user story is represented in the final requirements traceability.

## Step 1: Draft the Spec

Create `docs/PRODUCT_SPEC.md` with these sections:

1. **Product Overview** — What is this product? What problem does it solve? (2–3 paragraphs)
2. **Target Users** — User personas with goals and pain points. (If pre-existing stories imply personas, extract them from there.)
3. **User Stories** — Organized by persona. Format: *"As a [persona], I want [action] so that [benefit]."* (If provided via input file, include them verbatim and organize by persona. Add any missing stories only with human approval.)
4. **User Profile & Data Model** — What info do we need from each user? Include profile CRUD, account deletion (GDPR), and i18n considerations (timezone, locale, currency, language).
5. **Core Workflows** — Step-by-step description of the 3–5 most important user journeys. Describe each screen/state. (Derive from provided stories if available.)
6. **AI Integration** — Three tiers:
   - **Tier 1: Core Business Logic** — AI features that ARE the product. Define input, output, and fallback for each.
   - **Tier 2: Smart Suggestions** — Context-aware, proactive, non-blocking. Where do they appear? What triggers them?
   - **Tier 3: In-App Chatbot** — Scoped to app domain only. Define: memory strategy, guardrails (what it can/can't do), conversation starters.
7. **Admin Panel** — User management, usage analytics, AI usage dashboard, chatbot monitoring, audit log.
8. **Out of Scope (for MVP)** — Explicitly list what this version will NOT do.

## Step 2: Critical Review

After drafting, switch to critical reviewer mode. Find: gaps, contradictions, missing edge cases, unclear stories. Present feedback to the human. Iterate 2–3 times until both sides are satisfied.

## Step 3: Requirements Extraction

Once the spec is stable, append:

**Functional Requirements (FR)** — Numbered (FR-001, FR-002...). Each must be testable and traceable to a user story.

**Non-Functional Requirements (NFR)** — Performance targets, scalability, availability, accessibility (WCAG 2.1 AA), browser/device support, i18n.

## Step 4: Security Requirements

Append a Security section covering: authentication, registration controls, authorization (RBAC), session management, data protection, input validation, rate limiting, audit logging, and AI API security (keys as env secrets, backend-only AI calls, per-user rate limits, prompt injection defense, AI response validation, cost controls, server-side chatbot guardrails).

## Gate — 🧑 Human

Present the completed spec to the human for review. The gate requires:

- [ ] `PRODUCT_SPEC.md` is complete with all sections.
- [ ] Human has reviewed and approved the spec.
- [ ] Requirements are numbered and traceable to user stories.
- [ ] Security section is reviewed and approved.

Once approved, update `.planning/STATE.md` and log: **"Approved — moving to Architecture & Technical Design."**

## ➡️ Auto-Chain

This phase ends with a 🧑 Human gate. **STOP and wait** for the human to explicitly approve the gate checklist. Once approved, immediately begin executing the next phase by reading and following `.claude/commands/architect-mvpb.md`.
