#!/usr/bin/env bash
# PreToolUse hook: Enforce DECISIONS.md is append-only
# Blocks Edit operations on DECISIONS.md that remove existing content.
# Checks that new_string contains all of old_string (i.e., content is only added, never removed).

set -euo pipefail

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"//;s/"$//')

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Only care about DECISIONS.md
if ! echo "$FILE_PATH" | grep -qE '(^|/)DECISIONS\.md$'; then
  exit 0
fi

# Use python3 for reliable JSON parsing and string containment check
RESULT=$(echo "$INPUT" | python3 -c "
import sys, json

data = json.load(sys.stdin)
inp = data.get('input', {})
old = inp.get('old_string', '')
new = inp.get('new_string', '')

if not old:
    # No old_string means Write (initial creation) — allow
    print('allow')
elif not new:
    print('block_empty')
elif old in new:
    # old_string is fully contained in new_string — append-only preserved
    print('allow')
else:
    print('block_removal')
" 2>/dev/null || echo "allow")

case "$RESULT" in
  allow)
    exit 0
    ;;
  block_empty)
    echo "BLOCKED: Cannot replace content in DECISIONS.md with empty string. DECISIONS.md is append-only."
    exit 2
    ;;
  block_removal)
    echo "BLOCKED: DECISIONS.md is append-only. You cannot remove or modify existing entries. Only append new entries."
    exit 2
    ;;
  *)
    exit 0
    ;;
esac
