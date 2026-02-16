# Phase 7: Deployment & Launch Prep

You are the **PM / Team Lead** coordinating DevOps roles. Your goal is to get the application running in production with monitoring.

Read `CLAUDE.md`, `.planning/STATE.md`, `.planning/DECISIONS.md`, and `docs/ARCHITECTURE.md` first.

$ARGUMENTS

## Agent Teams Parallel Dispatch

The same Agent Teams rules from Phase 4 apply here. You are the orchestrator — delegate, don't do.

- **Step 2 parallelizes infrastructure tasks:** Many of the infra tasks (DNS/SSL, CI/CD pipeline, monitoring/error tracking, health check endpoint, structured logging, AI cost alerts) are independent. Spawn DevOps teammates for independent tasks simultaneously in a single message. Each teammate configures one piece of infrastructure, verifies it, and reports back.
- **Maximum 5 teammates per wave** (same cap as Phase 4). If more than 5 infra tasks are independent, split into sub-waves of ≤5.
- Dependencies still run sequentially (e.g., production domain must be configured before DNS records), but everything that can run in parallel should.
- **Shut down teammates between waves** via `shutdown_request` before spawning the next batch. At phase end, shut down all remaining teammates and call `TeamDelete`.
- All other Agent Teams rules (fresh context per task, handoff context, no sequential spawning of independent work, teammate cleanup) carry over from Phase 4.

## Step 0: Pre-Deployment Verification

Before any production deployment work begins, verify these prerequisites:

1. **Merge develop → main**: All approved milestone work must be on `main`. Run `git log main..develop` — if there are unmerged commits, merge and push now. This is a blocking prerequisite — do not proceed with deployment from `develop`.
2. **Verify containerized build from main**: Check out `main`, run `docker compose -f docker-compose.prod.yml up --build`. All services must start healthy. This confirms `main` has every file and config needed for production.
3. **Verify .env.example is complete**: Every env var used in the codebase, Dockerfile, docker-compose, and scripts must have a corresponding entry in `.env.example` with a description. Grep the codebase for `process.env.` and `${` references and cross-check.

If any verification fails, fix it before proceeding. Do not start production deployment with an incomplete `main` branch.

## Step 1: Production Deployment Scripts

Create production-ready scripts:

- **`scripts/deploy.sh`** — Test → lint → build → migrate → deploy → smoke test → output summary (version, timestamp, commit hash). Abort on any failure.
- **`scripts/deploy-rollback.sh`** — Identify previous version → revert → verify backward-compatible migrations → smoke test.
- **`scripts/seed.sh`** — Seed admin account + sample data. Configurable per environment.

Both deploy scripts must be tested end-to-end before the gate.

## Step 2: Production Domain & Infrastructure

**Parallelize with Agent Teams:** Items 1-3 must be sequential (domain → DNS → SSL), but once the domain is live, spawn DevOps teammates for items 4-9 simultaneously — they are independent of each other.

1. Configure the production domain.
2. Set up DNS records.
3. Configure SSL/TLS (auto-renewal).
4. Set up CI/CD pipeline:
   - Push to `develop`: tests, lint, type-check.
   - Merge to `main`: tests → build → deploy.
5. Configure production environment variables (including AI API keys).
6. Set up monitoring / error tracking (Sentry or equivalent).
7. Set up health check endpoint (`/api/health`) — verifies app running, DB connected, AI API reachable.
8. Configure structured JSON logging for production.
9. Set up AI cost monitoring alerts.

## Step 3: Pre-Launch Checklist

Verify each item:

- [ ] All tests pass in CI.
- [ ] Production domain is live and resolves.
- [ ] SSL certificate is valid and auto-renewing.
- [ ] `scripts/deploy.sh` executes successfully end-to-end.
- [ ] `scripts/deploy-rollback.sh` has been tested.
- [ ] Production env vars configured (including AI provider API key).
- [ ] Database migrated and seeded.
- [ ] Health check responds at `https://[domain]/api/health`.
- [ ] Error tracking receiving test events.
- [ ] Security headers set.
- [ ] Rate limiting active (including AI endpoints).
- [ ] AI API calls working in production (test one core feature).
- [ ] AI cost alerts configured.
- [ ] Admin account created.
- [ ] `.env.example` up to date.
- [ ] README has correct setup and deploy instructions.

## Step 4: Demo Script

Create `docs/DEMO.md`:

1. **Setup instructions** — How to get the demo environment running.
2. **Demo walkthrough** — Step-by-step: Registration → Core AI feature → Smart suggestions → Chatbot → Profile → Admin panel → AI usage dashboard.
3. **Talking points** — What to highlight at each screen.
4. **Known limitations** — What's not in the MVP.
5. **Sample data** — Seed data that makes the demo compelling.

## Gate — 🧑 Human

Present to the human:

- [ ] Application deployed and accessible at production domain.
- [ ] Deploy and rollback scripts work.
- [ ] Monitoring and AI cost alerts active.
- [ ] Demo script written and tested.
- [ ] Human has walked through the demo.

Once approved, update STATE.md. Log: **"Approved — moving to Iteration & Backlog. The product is live!"**

## ➡️ Auto-Chain

This phase ends with a 🧑 Human gate. **STOP and wait** for the human to explicitly approve the gate checklist. Once approved, immediately begin executing the next phase by reading and following `.claude/commands/iterate-mvpb.md`.
