#!/usr/bin/env bash
# Detect the OpenCode version that will consume these components.
# Prints the major version number (e.g. "2"). Prints nothing if undetectable.
#
# This lets install / check / update-check treat OpenCode v1.x.x and v2.x.x
# differently. Some components (workspace-layout, instructions) are only
# meaningful on v1; on v2 the AGENTS.md mechanism replaces them.

detect_opencode_major() {
  local ver=""

  # 1) opencode on PATH
  if command -v opencode >/dev/null 2>&1; then
    ver="$("opencode" --version 2>/dev/null | sed -n 's/^opencode v\([0-9]*\)\.[0-9]*\.[0-9]*$/\1/p')"
  fi

  # 2) desktop-bundled CLI (e.g. ~/.config/ai.opencode.desktop/cli/2.0.12/)
  if [ -z "$ver" ]; then
    for d in "$HOME/.config/ai.opencode.desktop/cli/"*/; do
      if [ -d "$d" ]; then
        ver="$(basename "$d")"
        break
      fi
    done
    ver="$(printf '%s' "$ver" | sed -n 's/^\([0-9]*\)\.[0-9]*\.[0-9]*$/\1/p')"
  fi

  printf '%s' "$ver"
}
