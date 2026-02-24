#!/usr/bin/env bash
# PostToolUse hook: Ensure STATE.md does not exceed 50 lines
# Checks after every write/edit whether STATE.md has grown too large.

set -euo pipefail

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"//;s/"$//')

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Only care about STATE.md
if ! echo "$FILE_PATH" | grep -qE '(^|/)STATE\.md$'; then
  exit 0
fi

if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

LINE_COUNT=$(wc -l < "$FILE_PATH" | tr -d ' ')

if [ "$LINE_COUNT" -gt 50 ]; then
  echo "BLOCKED: STATE.md has $LINE_COUNT lines (max 50). Move details to DECISIONS.md or LEARNINGS.md and trim STATE.md."
  exit 2
fi

exit 0
