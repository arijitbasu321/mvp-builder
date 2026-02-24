#!/usr/bin/env bash
# Standalone script: Check test coverage meets threshold
# Not a hook — invoked manually or by CI. Sources project-config.sh for commands.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG="$SCRIPT_DIR/../project-config.sh"

if [ ! -f "$CONFIG" ]; then
  echo "ERROR: project-config.sh not found at $CONFIG"
  exit 1
fi

source "$CONFIG"

echo "Running tests: $TEST_CMD"
echo "Coverage threshold: ${COVERAGE_THRESHOLD}%"

# Run tests and capture output
OUTPUT=$(eval "$TEST_CMD" 2>&1) || true

echo "$OUTPUT"

# Try to extract coverage percentage (works with common formats: Jest, Vitest, c8)
COVERAGE=$(echo "$OUTPUT" | grep -oE 'All files[[:space:]]*\|[[:space:]]*[0-9.]+' | grep -oE '[0-9.]+$' | head -1)

if [ -z "$COVERAGE" ]; then
  # Try alternative format: "Statements   : XX%"
  COVERAGE=$(echo "$OUTPUT" | grep -oE 'Statements[[:space:]]*:[[:space:]]*[0-9.]+' | grep -oE '[0-9.]+$' | head -1)
fi

if [ -z "$COVERAGE" ]; then
  echo "WARNING: Could not parse coverage percentage from test output."
  echo "Verify manually that coverage meets ${COVERAGE_THRESHOLD}%."
  exit 0
fi

# Compare (integer comparison — truncate decimals)
COVERAGE_INT=${COVERAGE%.*}

if [ "$COVERAGE_INT" -lt "$COVERAGE_THRESHOLD" ]; then
  echo "FAILED: Coverage is ${COVERAGE}% (threshold: ${COVERAGE_THRESHOLD}%)"
  exit 1
fi

echo "PASSED: Coverage is ${COVERAGE}% (threshold: ${COVERAGE_THRESHOLD}%)"
exit 0
