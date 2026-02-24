#!/usr/bin/env bash
# PreToolUse hook: Block Task tool calls without team_name
# Ensures all agent spawning goes through Agent Teams, not bare sub-agents.

set -euo pipefail

INPUT=$(cat)

# Check if team_name is present in the input
if echo "$INPUT" | grep -q '"team_name"'; then
  exit 0
fi

# Check if subagent_type is present — if not, this isn't an agent spawn
if ! echo "$INPUT" | grep -q '"subagent_type"'; then
  exit 0
fi

echo "BLOCKED: Task tool must include team_name. Use TeamCreate first, then spawn teammates with team_name. Bare sub-agents are not allowed — all work must go through Agent Teams with worktree isolation."
exit 2
