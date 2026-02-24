#!/usr/bin/env bash
# PreToolUse hook: Block modifications to REQUIREMENTS.md
# Reads tool input JSON from stdin, checks if file_path targets REQUIREMENTS.md

set -euo pipefail

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"//;s/"$//')

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

if echo "$FILE_PATH" | grep -qE '(^|/)REQUIREMENTS\.md$'; then
  echo "BLOCKED: REQUIREMENTS.md is read-only during Phase I. The Product Manager must never modify the human's requirements."
  exit 2
fi

exit 0
