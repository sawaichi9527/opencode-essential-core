#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${1:-$HOME/.config/opencode/skills}"
COMMAND_TARGET_DIR_OVERRIDE="${2:-}"
FORCE="${FORCE:-0}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_DIR="$REPO_ROOT/skills"
COMMAND_SOURCE_DIR="$REPO_ROOT/commands"

# Detect the consuming OpenCode version so v1-only components can be skipped on v2.
# shellcheck source=scripts/opencode-version.sh
source "$SCRIPT_DIR/opencode-version.sh"

# Components that are only meaningful on OpenCode v1.x.x. On v2 the built-in
# AGENTS.md mechanism replaces them, so we skip installing them.
OPTIONAL_ON_V2=(workspace-layout instructions)

OPCODE_MAJOR="$(detect_opencode_major)"
if [ -n "${OPCODE_MAJOR:-}" ] && [ "$OPCODE_MAJOR" -ge 2 ]; then
  V2_MODE=1
else
  V2_MODE=0
fi

# On OpenCode v2 use the modern plural commands/ directory; on v1 keep the
# legacy singular command/ directory. An explicit $2 override always wins.
if [ "$V2_MODE" -eq 1 ]; then
  COMMAND_TARGET_DIR="${COMMAND_TARGET_DIR_OVERRIDE:-$HOME/.config/opencode/commands}"
else
  COMMAND_TARGET_DIR="${COMMAND_TARGET_DIR_OVERRIDE:-$HOME/.config/opencode/command}"
fi

is_optional_on_v2() {
  local name="$1" candidate
  for candidate in "${OPTIONAL_ON_V2[@]}"; do
    if [ "$candidate" = "$name" ]; then
      return 0
    fi
  done
  return 1
}

mkdir -p "$TARGET_DIR"

for skill_dir in "$SOURCE_DIR"/*; do
  [[ -d "$skill_dir" ]] || continue
  name="$(basename "$skill_dir")"

  if [ "$V2_MODE" -eq 1 ] && is_optional_on_v2 "$name"; then
    echo "[SKIP] $name is v1-only; ignored on OpenCode v$OPCODE_MAJOR."
    continue
  fi

  destination="$TARGET_DIR/$name"

  if [[ -e "$destination" && "$FORCE" != "1" ]]; then
    echo "[SKIP] $name already exists. Run with FORCE=1 to replace."
    continue
  fi

  rm -rf "$destination"
  cp -R "$skill_dir" "$destination"
  echo "[OK] Installed $name"
done

if [[ -d "$COMMAND_SOURCE_DIR" ]]; then
  mkdir -p "$COMMAND_TARGET_DIR"
  for command_file in "$COMMAND_SOURCE_DIR"/*.md; do
    [[ -f "$command_file" ]] || continue
    name="$(basename "$command_file")"
    base_name="${name%.md}"

    if [ "$V2_MODE" -eq 1 ] && is_optional_on_v2 "$base_name"; then
      echo "[SKIP] command/$name is v1-only; ignored on OpenCode v$OPCODE_MAJOR."
      continue
    fi

    destination="$COMMAND_TARGET_DIR/$name"
    if [[ -e "$destination" && "$FORCE" != "1" ]]; then
      echo "[SKIP] command $name already exists. Run with FORCE=1 to replace."
      continue
    fi
    cp "$command_file" "$destination"
    echo "[OK] Installed command $name"
  done
fi

echo "Done. Restart OpenCode before validation."
