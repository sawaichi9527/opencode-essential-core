---
description: Manually compare the installed OpenCode teamwork repositories and ask before applying updates
---

Load and follow the `teamwork-update-check` Skill.

This command is manual only. Query each repository's published manifest (`manifest/skills.json` for Core, `manifest/packs.json` for Extension Packs) and `VERSION`, compare them with the local installation baseline, detect skill and plugin version updates, report changes with compatibility notes, and ask for confirmation before modifying files or installing packages.

On OpenCode v2 (major ≥ 2), skip components marked `optionalOnV2` in the manifest (`workspace-layout` skill and `instructions` command); they are v1-only and replaced by the built-in AGENTS.md mechanism.