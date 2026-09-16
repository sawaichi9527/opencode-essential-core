---
description: Manually compare the installed OpenCode teamwork repositories and ask before applying updates
---

Load and follow the `teamwork-update-check` Skill.

This command is manual only. Query each repository's published manifest (`manifest/skills.json` for Core, `manifest/packs.json` for Extension Packs) and `VERSION`, compare them with the local installation baseline, detect skill and plugin version updates, report changes with compatibility notes, and ask for confirmation before modifying files or installing packages.