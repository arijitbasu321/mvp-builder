#!/usr/bin/env bash
# Project-specific configuration — filled per project during setup.
# Sourced by hook scripts that need tech-stack-specific commands.

# Test command with coverage output
export TEST_CMD="npm test -- --coverage"

# Minimum coverage percentage required
export COVERAGE_THRESHOLD=80

# Playwright E2E test directory
export PLAYWRIGHT_TEST_DIR="tests/e2e"
