#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${1:-$HOME/.config/opencode/skills}"
FORCE="${FORCE:-0}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_DIR="$REPO_ROOT/skills"

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

echo "Done. Restart OpenCode before validation."
