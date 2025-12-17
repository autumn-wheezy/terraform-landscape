#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./scripts/landscape-plan.sh [terraform plan args...]
#
# Examples:
#   ./scripts/landscape-plan.sh -var-file=dev.tfvars
#   ./scripts/landscape-plan.sh -chdir=infra

if ! command -v terraform >/dev/null 2>&1; then
  echo "terraform is not installed (or not in PATH)" >&2
  exit 1
fi

# Prefer local bundle exec if present
LANDSCAPE_CMD="landscape"
if [ -f "Gemfile" ]; then
  if command -v bundle >/dev/null 2>&1; then
    bundle check >/dev/null 2>&1 || bundle install
    LANDSCAPE_CMD="bundle exec landscape"
  fi
fi

# Force no-color to avoid ANSI artifacts in CI logs
terraform plan -no-color "$@" | eval "$LANDSCAPE_CMD"
