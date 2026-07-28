# Upstream and Adaptation Notes

## Primary upstream

- Project: `mathruffian-dot/opencode-lazy-packs`
- Source: `https://github.com/mathruffian-dot/opencode-lazy-packs`
- License: MIT
- Original copyright: 2026 三師爸 Sense Bar

## Adaptation direction

This repository is not a direct mirror. It reorganizes selected concepts into a smaller,
cross-platform OpenCode core for a small SWQA-oriented development team.

Initial changes include:

- split essential behavior from optional integrations;
- remove the root interactive installer pattern that can shadow child skills;
- align every Skill frontmatter `name` with its directory name;
- replace teacher/cloud-specific assumptions with general development wording;
- use PowerShell for native Windows and Bash for WSL/Linux/macOS;
- keep Git hosting integrations outside the core;
- retain Traditional Chinese as the primary documentation language.

Future upstream changes should be reviewed and selectively adapted rather than merged automatically.
