#!/usr/bin/env bash
set -euo pipefail

# Determine project directory (default: current directory)
TARGET="${1:-.}"

if [[ ! -d "$TARGET" ]]; then
  echo "Error: Directory '$TARGET' does not exist."
  exit 1
fi

# Verify Phase I outputs exist
ERRORS=()

if [[ ! -f "$TARGET/SPEC.md" ]]; then
  ERRORS+=("SPEC.md not found — Phase I may not be complete")
fi

if [[ ! -f "$TARGET/PROJECT-MANAGER-PLAYBOOK.md" ]]; then
  ERRORS+=("PROJECT-MANAGER-PLAYBOOK.md not found — Phase I may not be complete")
fi

if [[ ! -f "$TARGET/hooks/project-manager/settings.json" ]]; then
  ERRORS+=("hooks/project-manager/settings.json not found")
fi

if [[ ${#ERRORS[@]} -gt 0 ]]; then
  echo "Error: Cannot transition to Phase II:"
  for err in "${ERRORS[@]}"; do
    echo "  - $err"
  done
  exit 1
fi

echo "Transitioning to Phase II in: $TARGET"
echo ""

# Swap CLAUDE.md symlink to project-specific Project Manager playbook
if [[ -f "$TARGET/CLAUDE.md" || -L "$TARGET/CLAUDE.md" ]]; then
  rm "$TARGET/CLAUDE.md"
fi
ln -s PROJECT-MANAGER-PLAYBOOK.md "$TARGET/CLAUDE.md"
echo "[1/2] CLAUDE.md -> PROJECT-MANAGER-PLAYBOOK.md"

# Install Project Manager hooks
cp "$TARGET/hooks/project-manager/settings.json" "$TARGET/.claude/settings.json"
echo "[2/2] Installed Project Manager hooks in .claude/settings.json"

echo ""
echo "Phase II ready. Start with: cd $TARGET && claude"
