#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${1:-$HOME/.config/opencode/skills}"
COMMAND_TARGET_DIR_OVERRIDE="${2:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# This pack targets OpenCode v2 only: verify the plural commands/ directory.
# An explicit $2 override always wins.
COMMAND_TARGET_DIR="${COMMAND_TARGET_DIR_OVERRIDE:-$HOME/.config/opencode/commands}"

expected=(
  environment-check
  config-check
  project-init
  session-start
  session-close
  git-basic
  workspace-layout
  teamwork-update-check
)

failed=0
for name in "${expected[@]}"; do
  if [[ -f "$TARGET_DIR/$name/SKILL.md" ]]; then
    echo "[OK] $name"
  else
    echo "[MISSING] $name"
    failed=1
  fi
done

command_files=(teamwork-update-check.md)

COMMAND_DIR_LABEL="$(basename "$COMMAND_TARGET_DIR")"

for command_file in "${command_files[@]}"; do
  if [[ -f "$COMMAND_TARGET_DIR/$command_file" ]]; then
    echo "[OK] ${COMMAND_DIR_LABEL}/$command_file"
  else
    echo "[MISSING] ${COMMAND_DIR_LABEL}/$command_file"
    failed=1
  fi
done

project_init_references=(
  AGENTS.template.md
  handoff.template.md
)
for reference in "${project_init_references[@]}"; do
  if [[ -f "$TARGET_DIR/project-init/references/$reference" ]]; then
    echo "[OK] project-init/references/$reference"
  else
    echo "[MISSING] project-init/references/$reference"
    failed=1
  fi
done

if [ "$failed" -ne 0 ]; then
  exit 1
fi

echo "Essential Core validation passed."
