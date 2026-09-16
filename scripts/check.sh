#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${1:-$HOME/.config/opencode/skills}"
COMMAND_TARGET_DIR="${2:-$HOME/.config/opencode/command}"
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

if [[ -f "$COMMAND_TARGET_DIR/teamwork-update-check.md" ]]; then
  echo "[OK] command/teamwork-update-check.md"
else
  echo "[MISSING] command/teamwork-update-check.md"
  failed=1
fi

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

if [[ "$failed" -ne 0 ]]; then
  exit 1
fi

echo "Essential Core validation passed."
