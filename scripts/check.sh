#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${1:-$HOME/.config/opencode/skills}"
COMMAND_TARGET_DIR_OVERRIDE="${2:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/opencode-version.sh
source "$SCRIPT_DIR/opencode-version.sh"
OPCODE_MAJOR="$(detect_opencode_major)"
if [ -n "${OPCODE_MAJOR:-}" ] && [ "$OPCODE_MAJOR" -ge 2 ]; then
  V2_MODE=1
else
  V2_MODE=0
fi

# On OpenCode v2 verify the modern plural commands/ directory; on v1 keep the
# legacy singular command/ directory. An explicit $2 override always wins.
if [ "$V2_MODE" -eq 1 ]; then
  COMMAND_TARGET_DIR="${COMMAND_TARGET_DIR_OVERRIDE:-$HOME/.config/opencode/commands}"
else
  COMMAND_TARGET_DIR="${COMMAND_TARGET_DIR_OVERRIDE:-$HOME/.config/opencode/command}"
fi

# workspace-layout is v1-only: on OpenCode v2 the built-in AGENTS.md mechanism
# replaces it, so it is not expected to be installed.
expected=(
  environment-check
  config-check
  project-init
  session-start
  session-close
  git-basic
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

if [ "$V2_MODE" -eq 1 ]; then
  # instructions is v1-only; skip it on v2.
  command_files=(teamwork-update-check.md)
else
  command_files=(
    teamwork-update-check.md
    instructions.md
  )
fi

# Label for display: reflects the actual directory used (commands/ on v2, command/ on v1).
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
