---
description: Inspect which instruction files OpenCode actually loads, and wire the workspace layer into opencode.jsonc after confirmation
---

Load and follow the `workspace-layout` Skill.

This command is manual only and covers two things.

**Inspect** — report which instruction files are loaded, using OpenCode's real rules:

1. Project rules: `AGENTS.md`, then `CLAUDE.md`, then `CONTEXT.md`. The first name that matches wins, and the search walks up from the current directory but **stops at the worktree (git root)**. In `workspace/projects/<project>/` the search therefore never reaches the workspace root.
2. Global rules: `~/.config/opencode/AGENTS.md`.
3. `instructions` entries from the merged config. These are additive, do not use the upward search, and are NOT shadowed by a project `AGENTS.md`.

Report each loaded source as a path, and state the effective `worktree` so the boundary is explicit.

**Configure** — when the workspace layer is not loaded, show the exact `instructions` block that would be added to `~/.config/opencode/opencode.jsonc`, including the workspace-level `AGENTS.md` and `WORKSPACE.md` paths. Do not write anything before the user confirms.

Never publish local configuration, secrets, internal endpoints, or provider credentials. A configuration merge must preserve unrelated providers, plugins, MCP servers, and user-specific values. Validate the file as JSONC after any edit and report the result.
