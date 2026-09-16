# Changelog

## 0.2.2 - Update-check query manifest and upgrade flow

- Added `manifest/skills.json` as the machine-readable Core component manifest for previously installed users.
- Reworked `teamwork-update-check` to query the two repositories' published manifests, compare them with the local installation baseline (`schemaVersion` 2), notify the user of skill and plugin version updates, and ask for confirmation before applying.
- Updated the baseline example to Core `0.2.2` and Extension Packs `0.2.4`.
- Updated the README status marker to `v0.2.2`.

## 0.2.1 - Teamwork baseline example refresh

- Updated the `teamwork-update-check` baseline example to Extension Packs `0.2.3`.
- Updated the README status marker to `v0.2.1`.

## 0.2.0 - Extension workflow compatibility

- Synchronized the Core version with the current maintenance baseline.
- Clarified that Extension Packs use `default`, `recommended`, and `optional` as installation tiers.
- Added guidance for displaying `category: other` without treating it as a new tier.
- Documented `hybrid-workflow` profiles, including generic local, team 28500 aeon, and cloud cheap Builder backends.
- Updated the teamwork baseline example to Core `0.2.0` and Extension Packs `0.2.1`.

## 0.1.1 - Fresh validation evidence

- Required fresh verification evidence before completion or passing claims.
- Expanded `handoff.md` with command, execution timestamp, duration, exit code, result, environment, DUT, UART, PCAP, report, and unverified-scope fields.
- Strengthened `session-close` to select existing project verification before inventing commands, and to distinguish document checks from Runtime or DUT validation.
- Moved project templates into `project-init/references/` so they remain available after Skill installation.
- Added installed-reference checks to PowerShell and Bash validation scripts.
- Extended `config-check` to inspect global and project Commands, shadowing, frontmatter, and referenced Agents.
- Adapted the evidence-before-claims principle without importing the Superpowers plugin or workflow framework.

## 0.1.0 - Initial planning baseline

- Established the Essential Core repository structure.
- Added six cross-platform core Skills.
- Added minimal PowerShell and Bash installers/checkers.
- Added reusable project and OpenCode configuration templates.
- Documented upstream attribution and the Core/Extension split.
