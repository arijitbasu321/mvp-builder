#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: ./setup.sh <project-directory> [user-stories-file]"
  echo ""
  echo "  <project-directory>    Path to the project repo (must exist)"
  echo "  [user-stories-file]    Optional: epics/user stories file to copy"
  exit 1
fi

TARGET="$1"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [[ ! -d "$TARGET" ]]; then
  echo "Error: Directory '$TARGET' does not exist."
  exit 1
fi

# Copy commands
mkdir -p "$TARGET/.claude/commands"
cp "$SCRIPT_DIR/.claude/commands/"*-mvpb.md "$TARGET/.claude/commands/"
echo "Copied commands to $TARGET/.claude/commands/"

# Copy settings if present
if [[ -f "$SCRIPT_DIR/.claude/settings.local.json" ]]; then
  cp "$SCRIPT_DIR/.claude/settings.local.json" "$TARGET/.claude/settings.local.json"
  echo "Copied settings.local.json"
fi

# Copy playbook
cp "$SCRIPT_DIR/APP_BUILDER_PLAYBOOK_3.md" "$TARGET/"
echo "Copied APP_BUILDER_PLAYBOOK_3.md"

# Copy user stories file if provided
if [[ $# -ge 2 ]]; then
  STORIES="$2"
  if [[ -f "$STORIES" ]]; then
    cp "$STORIES" "$TARGET/"
    echo "Copied $(basename "$STORIES") to $TARGET/"
  else
    echo "Warning: User stories file '$STORIES' not found, skipping."
  fi
fi

echo ""
echo "Done. Now:"
echo "  cd $TARGET"
echo "  claude --dangerously-skip-permissions"
echo "  /start-mvpb"
