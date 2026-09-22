---
description: Manually compare the installed OpenCode teamwork repositories and ask before applying updates
---

Load and follow the `teamwork-update-check` Skill.

This command is manual only. Query each repository's published manifest (`manifest/skills.json` for Core, `manifest/packs.json` for Extension Packs) and `VERSION`, compare them with the local installation baseline, detect skill and plugin version updates, report changes with compatibility notes, and ask for confirmation before modifying files or installing packages.

Core targets OpenCode v2.x.x only. If the local OpenCode major version is below 2 (or cannot be confirmed), report a `COMPATIBILITY` note instead of skipping the read-only check.