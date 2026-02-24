# App Builder

A framework for building production-ready applications using Claude Code. Instead of a monolithic playbook with instructions agents ignore, this framework uses **decoupled phases**, **human gatekeeping**, and **hooks that mechanically enforce rules**. You provide the requirements. Two AI Product Managers handle specification and development.

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

# Fill in project details (deployment platform, domain, AI provider, constraints)
vi /path/to/your-project/templates/PRODUCT-MANAGER-PLAYBOOK.md

# Start Phase I — the Product Manager reads your requirements and produces specs
cd /path/to/your-project
claude
```

## Phase Transition (I → II)

After the Product Manager completes Phase I and you've reviewed the output:

```bash
cd /path/to/your-project

# Swap the playbook symlink
ln -sf PROJECT-MANAGER-PLAYBOOK.md CLAUDE.md

# Install Project Manager hooks
cp hooks/project-manager/settings.json .claude/settings.json

# Start Phase II
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
│   │   ├── settings.json                  # Phase I hook config
│   │   └── scripts/
│   │       ├── block-requirements-edit.sh # Prevents AI from modifying REQUIREMENTS.md
│   │       └── validate-spec-structure.sh # Ensures SPEC.md has all required sections
│   └── project-manager/
│       ├── settings.json                  # Phase II hook config
│       ├── project-config.sh              # Test commands, coverage thresholds (fill per project)
│       └── scripts/
│           ├── enforce-team-worktrees.sh  # Blocks bare sub-agents (must use Agent Teams)
│           ├── enforce-issues-writer.sh   # Only PM can write ISSUES.md
│           ├── enforce-state-size.sh      # STATE.md stays under 50 lines
│           ├── enforce-test-coverage.sh   # Checks test coverage meets threshold
│           └── enforce-decisions-append.sh # DECISIONS.md is append-only
└── .claude/
    └── settings.json                      # Active hook config (swapped between phases)
```

Files created during execution:

```
your-project/
├── SPEC.md                                # Product specification (Phase I output)
├── PROJECT-MANAGER-PLAYBOOK.md            # Filled development playbook (Phase I output)
├── HOOK-RECOMMENDATIONS.md                # Suggested hook changes (Phase I output)
├── milestones/
│   ├── M1-SPEC.md                         # Per-milestone specs (Phase I output)
│   ├── M2-SPEC.md
│   └── ...
├── DESIGN-M{N}.md                         # Architect's design per milestone (Phase II)
├── STATE.md                               # Current progress (Phase II)
├── DECISIONS.md                           # Decision log — append-only (Phase II)
├── LEARNINGS.md                           # Active learnings (Phase II)
├── LEARNINGS-archive.md                   # Archived learnings (Phase II)
└── ISSUES.md                              # Issue tracker — PM-only (Phase II)
```

## Hook Configuration

Hooks enforce rules mechanically — agents cannot bypass them.

### Phase I Hooks (Product Manager)

| Hook | Trigger | What It Does |
|------|---------|-------------|
| block-requirements-edit | PreToolUse on Edit/Write | Prevents modification of REQUIREMENTS.md |
| validate-spec-structure | PostToolUse on Write | Ensures SPEC.md contains all required sections |

### Phase II Hooks (Project Manager)

| Hook | Trigger | What It Does |
|------|---------|-------------|
| enforce-team-worktrees | PreToolUse on Task | Blocks Task calls without team_name (no bare sub-agents) |
| enforce-issues-writer | PreToolUse on Edit/Write | Blocks teammates from writing to ISSUES.md |
| enforce-state-size | PostToolUse on Write/Edit | Blocks STATE.md from exceeding 50 lines |
| enforce-decisions-append | PreToolUse on Edit | Blocks edits that remove content from DECISIONS.md |

### Customizing Hooks

Edit `hooks/project-manager/project-config.sh` to set project-specific values:

```bash
export TEST_CMD="npm test -- --coverage"    # Your test command
export COVERAGE_THRESHOLD=80                 # Minimum coverage %
export PLAYWRIGHT_TEST_DIR="tests/e2e"       # E2E test directory
```

## What Hooks Cannot Enforce

Some rules require judgment and must rely on playbook instructions:

- Parallel teammate dispatch (no hook for sequential vs parallel spawning)
- Compressed report format (SendMessage content is not hookable)
- Review quality (requires understanding, not pattern matching)
- Wave plan correctness (requires understanding feature dependencies)

## Your Role

| When | What You Do |
|------|------------|
| Before Phase I | Write REQUIREMENTS.md, fill playbook placeholders |
| During Phase I | Answer Product Manager questions, review spec output |
| Between phases | Review all Phase I output, swap symlink, install hooks |
| During Phase II | Test at milestone gates, provide API keys, unblock escalations |

## License

MIT
