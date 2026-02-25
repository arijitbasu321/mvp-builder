#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [[ $# -lt 1 ]]; then
  echo "Usage: ./setup.sh <project-directory>"
  echo ""
  echo "  <project-directory>    Path to the project repo (must be an existing git repo)"
  echo ""
  echo "This copies the App Builder framework into your project:"
  echo "  - Templates (spec, milestone, playbooks)"
  echo "  - Hooks (product-manager and project-manager)"
  echo "  - Empty REQUIREMENTS.md"
  echo "  - CLAUDE.md symlink -> Product Manager playbook (Phase I)"
  exit 1
fi

TARGET="$1"

if [[ ! -d "$TARGET" ]]; then
  echo "Error: Directory '$TARGET' does not exist."
  exit 1
fi

if [[ ! -d "$TARGET/.git" ]]; then
  echo "Error: '$TARGET' is not a git repository. Initialize with 'git init' first."
  exit 1
fi

echo "Setting up App Builder in: $TARGET"
echo ""

# --- Copy templates ---
mkdir -p "$TARGET/templates"
cp "$SCRIPT_DIR/templates/SPEC-TEMPLATE.md" "$TARGET/templates/"
cp "$SCRIPT_DIR/templates/MILESTONE-TEMPLATE.md" "$TARGET/templates/"
cp "$SCRIPT_DIR/templates/PRODUCT-MANAGER-PLAYBOOK.md" "$TARGET/templates/"
cp "$SCRIPT_DIR/templates/PROJECT-MANAGER-PLAYBOOK.md" "$TARGET/templates/"
echo "[1/5] Copied templates"

# --- Copy hooks ---
mkdir -p "$TARGET/hooks/product-manager"
mkdir -p "$TARGET/hooks/project-manager"

PM_HOOKS="$SCRIPT_DIR/hooks/product-manager/settings.json"
PJM_HOOKS="$SCRIPT_DIR/hooks/project-manager/settings.json"

cp "$PM_HOOKS" "$TARGET/hooks/product-manager/settings.json"
cp "$PJM_HOOKS" "$TARGET/hooks/project-manager/settings.json"
echo "[2/5] Copied hooks"

# --- Install product-manager hooks as initial .claude/settings.json ---
mkdir -p "$TARGET/.claude"

if [[ -f "$TARGET/.claude/settings.json" ]]; then
  # Merge hooks into existing settings using python3
  python3 -c "
import json, sys

with open('$TARGET/.claude/settings.json') as f:
    existing = json.load(f)

with open('$PM_HOOKS') as f:
    pm_hooks = json.load(f)

existing['hooks'] = pm_hooks.get('hooks', {})

with open('$TARGET/.claude/settings.json', 'w') as f:
    json.dump(existing, f, indent=2)
    f.write('\n')
" 2>/dev/null || cp "$PM_HOOKS" "$TARGET/.claude/settings.json"
else
  cp "$PM_HOOKS" "$TARGET/.claude/settings.json"
fi
echo "[3/5] Installed Product Manager hooks in .claude/settings.json"

# --- Create REQUIREMENTS.md ---
if [[ ! -f "$TARGET/REQUIREMENTS.md" ]]; then
  cat > "$TARGET/REQUIREMENTS.md" << 'REQEOF'
# Requirements

## Product Vision

<!-- What is this product? Who is it for? What problem does it solve? -->

## User Stories

<!-- Write user stories in this format: -->
<!-- - As a [type of user], I want [feature] so that [benefit] -->

## Constraints

<!-- Any technical, business, or design constraints -->

## Out of Scope

<!-- What this MVP will NOT include -->
REQEOF
  echo "[4/5] Created REQUIREMENTS.md"
else
  echo "[4/5] REQUIREMENTS.md already exists — skipped"
fi

# --- Create CLAUDE.md symlink ---
if [[ -f "$TARGET/CLAUDE.md" || -L "$TARGET/CLAUDE.md" ]]; then
  rm "$TARGET/CLAUDE.md"
fi
ln -s templates/PRODUCT-MANAGER-PLAYBOOK.md "$TARGET/CLAUDE.md"
echo "[5/5] Created CLAUDE.md -> templates/PRODUCT-MANAGER-PLAYBOOK.md"

echo ""
echo "========================================="
echo "  Setup complete!"
echo "========================================="
echo ""
echo "Next steps:"
echo ""
echo "  1. Write your requirements:"
echo "     vi $TARGET/REQUIREMENTS.md"
echo ""
echo "  2. Start Phase I (Specification):"
echo "     cd $TARGET && claude"
echo ""
echo "  3. After Phase I completes and you've reviewed the output:"
echo "     ln -sf PROJECT-MANAGER-PLAYBOOK.md CLAUDE.md"
echo "     cp hooks/project-manager/settings.json .claude/settings.json"
echo "     claude"
echo ""
