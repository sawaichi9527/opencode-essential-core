#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${1:-$HOME/.config/opencode/skills}"
COMMAND_TARGET_DIR="${2:-$HOME/.config/opencode/command}"
FORCE="${FORCE:-0}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_DIR="$REPO_ROOT/skills"
COMMAND_SOURCE_DIR="$REPO_ROOT/command"

mkdir -p "$TARGET_DIR"

for skill_dir in "$SOURCE_DIR"/*; do
  [[ -d "$skill_dir" ]] || continue
  name="$(basename "$skill_dir")"
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
