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

## Quick Start

```bash
# Clone this repo
git clone <repo-url>
cd builder

# Set up your project
./setup.sh /path/to/your-project

# Write your requirements
vi /path/to/your-project/REQUIREMENTS.md

# Start Phase I
cd /path/to/your-project
claude
```

## Phase Transition (I → II)

After the Product Manager completes Phase I and you've reviewed the output:

```bash
# Run the transition script (validates Phase I output, swaps symlink, installs hooks)
./transition.sh /path/to/your-project

# Start Phase II
cd /path/to/your-project
claude
```

## Directory Structure

After running `setup.sh`, your project will have:

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
| Between phases | Review all Phase I output, run `transition.sh` |
| During Phase II | Test at milestone gates, provide API keys, unblock escalations |

## License

MIT
