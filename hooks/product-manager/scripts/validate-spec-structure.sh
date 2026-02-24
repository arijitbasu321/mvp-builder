#!/usr/bin/env bash
# PostToolUse hook: Validate SPEC.md has all required section headers
# Reads tool input JSON from stdin, checks if the written file is SPEC.md,
# then validates it contains all required sections.

set -euo pipefail

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"//;s/"$//')

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

if ! echo "$FILE_PATH" | grep -qE '(^|/)SPEC\.md$'; then
  exit 0
fi

if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

REQUIRED_HEADERS=(
  "Project Overview"
  "Agent Team Structure"
  "Tech Stack"
  "Deployment Strategy"
  "Golden Rules"
  "Review Structure"
  "Development Milestones"
)

MISSING=()
for header in "${REQUIRED_HEADERS[@]}"; do
  if ! grep -q "## $header" "$FILE_PATH"; then
    MISSING+=("$header")
  fi
done

if [ ${#MISSING[@]} -gt 0 ]; then
  echo "BLOCKED: SPEC.md is missing required sections: ${MISSING[*]}"
  echo "All sections from the spec template must be present."
  exit 2
fi

exit 0
