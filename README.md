# App Builder

A framework for building production-ready applications using Claude Code. This framework uses **decoupled phases** and **human gatekeeping**. You provide the requirements. Two AI Product Managers handle specification and development.

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed
- Git repository for your project
- Agent Teams enabled in Claude Code settings

## Three Phases

| Phase | Who | What Happens |
|-------|-----|-------------|
| **Requirement** | Human | You write user stories in REQUIREMENTS.md |
| **Specification** (Phase I) | AI — Product Manager | Converts requirements into spec, milestones, and a development playbook |
| **Development** (Phase II) | AI — Project Manager | Builds the product milestone by milestone using Agent Teams |

The human is the gatekeeper between phases. Nothing advances without your review and approval.

## Setup

Copy the framework into your project manually:

```bash
# Copy templates
cp -r templates/ /path/to/your-project/templates/

# Copy hooks
cp -r hooks/ /path/to/your-project/hooks/

# Create CLAUDE.md symlink pointing to Phase I playbook
cd /path/to/your-project
ln -s templates/PRODUCT-MANAGER-PLAYBOOK.md CLAUDE.md

# Install Phase I hooks
mkdir -p .claude
cp hooks/product-manager/settings.json .claude/settings.json

# Write your requirements
vi REQUIREMENTS.md

# Start Phase I
claude
```

## Phase Transition (I → II)

After the Product Manager completes Phase I and you've reviewed the output:

1. Review `HOOK-RECOMMENDATIONS.md` and apply any hook changes you agree with
2. Swap CLAUDE.md and hooks:

```bash
cd /path/to/your-project
ln -sf PROJECT-MANAGER-PLAYBOOK.md CLAUDE.md
cp hooks/project-manager/settings.json .claude/settings.json

# Start Phase II
claude
```

## Directory Structure

After setup, your project will have:

```
your-project/
├── CLAUDE.md                              → templates/PRODUCT-MANAGER-PLAYBOOK.md (symlink)
├── REQUIREMENTS.md                        # Your user stories (human-authored)
├── templates/
│   ├── SPEC-TEMPLATE.md                   # Structure for the spec document
│   ├── MILESTONE-TEMPLATE.md              # Structure for per-milestone specs
│   ├── PRODUCT-MANAGER-PLAYBOOK.md        # Phase I instructions
│   └── PROJECT-MANAGER-PLAYBOOK.md        # Phase II instructions (template)
├── hooks/
│   ├── product-manager/
│   │   └── settings.json                  # Phase I hook config (empty — PM doesn't spawn agents)
│   └── project-manager/
│       └── settings.json                  # Phase II hook — outputs golden rules before each Task
└── .claude/
    └── settings.json                      # Active hook config (swapped between phases)
```

Files created during execution:

```
your-project/
├── SPEC.md                                # Product specification (Phase I output)
├── PROJECT-MANAGER-PLAYBOOK.md            # Project-specific development playbook (Phase I output)
├── HOOK-RECOMMENDATIONS.md                # Suggested hook changes (Phase I output)
├── milestones/
│   ├── M1-SPEC.md                         # Per-milestone specs (Phase I output)
│   ├── M2-SPEC.md
│   └── ...
├── DESIGN.md                              # Overall project design — UI/UX + architecture (Phase II)
├── DESIGN-M{N}.md                         # Per-milestone design — UI/UX + architecture (Phase II)
├── STATE.md                               # Current progress (Phase II)
├── DECISIONS.md                           # Decision log — append-only (Phase II)
├── LEARNINGS.md                           # Active learnings (Phase II)
├── LEARNINGS-archive.md                   # Archived learnings (Phase II)
└── ISSUES.md                              # Issue tracker — PM-only (Phase II)
```

## Hooks

Phase II has one hook: before every `Task` call, the golden rules are output into the agent's context. This ensures every spawned agent sees the rules before it starts working.

The golden rules are embedded directly in `hooks/project-manager/settings.json`. To customize them for your project, edit the rules in that file after Phase I.

## Your Role

| When | What You Do |
|------|------------|
| Before Phase I | Write REQUIREMENTS.md |
| During Phase I | Answer Product Manager questions, review spec output |
| Between phases | Review all Phase I output, review HOOK-RECOMMENDATIONS.md, swap CLAUDE.md and hooks |
| During Phase II | Test at milestone gates, provide API keys, unblock escalations |

## License

MIT
