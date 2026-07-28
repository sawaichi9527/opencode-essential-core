# Upstream and Adaptation Notes

## Primary upstream

- Project: `mathruffian-dot/opencode-lazy-packs`
- Source: `https://github.com/mathruffian-dot/opencode-lazy-packs`
- License: MIT
- Original copyright: 2026 三師爸 Sense Bar

## Additional references

### `multica-ai/andrej-karpathy-skills`

- License: MIT
- Concepts adapted:
  - think before coding;
  - keep implementations simple;
  - make surgical changes;
  - define verifiable success criteria.

### `DietrichGebert/ponytail`

- License: MIT
- Concepts selectively adapted:
  - reuse existing code before writing new code;
  - prefer standard libraries and native platform features;
  - fix shared root causes rather than individual symptoms;
  - review diffs for unnecessary complexity.

No Ponytail plugin runtime, lifecycle hooks, mode state, benchmark suite, or cross-agent adapters are included.

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
- retain Traditional Chinese as the primary documentation language;
- keep always-on coding guidance in the project `AGENTS.md` rather than an additional plugin or hook;
- use only OpenCode-native project rules, Skills, configuration, and permissions.

Future upstream changes should be reviewed and selectively adapted rather than merged automatically.
