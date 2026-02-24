#!/usr/bin/env bash
# PreToolUse hook: Block non-PM writes to ISSUES.md
# If the current working directory is inside a worktree, the agent is a teammate
# and must not write to ISSUES.md directly.

set -euo pipefail

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"//;s/"$//')

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Only care about ISSUES.md
if ! echo "$FILE_PATH" | grep -qE '(^|/)ISSUES\.md$'; then
  exit 0
fi

# Check if we're in a worktree (teammate) by looking for .git file (worktrees have a .git file, not directory)
if [ -f ".git" ]; then
  echo "BLOCKED: Only the Project Manager can write to ISSUES.md. Report issues to the PM via SendMessage."
  exit 2
fi

exit 0
