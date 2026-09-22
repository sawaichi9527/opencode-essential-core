# Changelog

## 2.0.14 - User-invocable commands for core skills

- Added 5 thin commands so workflows that were previously skill-only can be run directly: `/project-init`, `/environment-check`, `/config-check`, `/session-start`, `/session-close`. Each wrapper loads its same-named Skill; `/project-init` is scoped to brand-new or empty projects, and existing projects should use the built-in `/init`.
- The read-only commands (`/environment-check`, `/config-check`, `/session-start`) set `agent: plan`.
- Updated `scripts/check.*` to expect all six commands, registered the command components in `manifest/skills.json`, and rewrote the README Commands section and repository tree.
- Documented the full OpenCode v2 skill discovery set: the native global `~/.config/opencode/skills/` and project `.opencode/skills/`, plus the compatibility `~/.agents/skills/` and `.agents/skills/` (where `npx skills add -g -a opencode` installs). Updated the README "OpenCode 使用邊界" and 安裝 sections; `config-check` now lists and checks the compatibility directories and flags duplicate IDs across sources.
- Removed the stale `hybrid-workflow` description from the README (that pack was removed in Extension Packs 2.0.12).
- Bumped the version to 2.0.14.

## 2.0.12 - OpenCode v2 only, v1 compatibility removed

- Version scheme changed: the pack version now records the OpenCode version this release was validated against (2.0.12), instead of the previous 0.x line. The pack does not bump just because OpenCode released a new version; the next review round of this pack will adopt the OpenCode version current at that time.

- Dropped OpenCode v1.x.x support: the pack now targets v2.x.x exclusively. This is a breaking change for v1 deployments.
- Removed the `instructions` command entirely (it depended on v1's `opencode.jsonc` `instructions` field, which v2 does not parse).
- Kept the `workspace-layout` Skill for multi-repo boundary guidance; its rule-loading section now describes the v2-native approach (global `~/.config/opencode/AGENTS.md` for workspace-wide rules instead of the v1 `instructions` field) and no longer references `/instructions`.
- Deleted `scripts/opencode-version.sh` / `scripts/opencode-version.ps1`; `install.*` and `check.*` no longer detect the major version and always use the plural `commands/` directory.
- `check.*` expects all eight Skills (including `workspace-layout`) and one Command.
- Removed `optionalOnV2` from `manifest/skills.json`; `teamwork-update-check` now reports a `COMPATIBILITY` note instead of skipping components when OpenCode major < 2.
- Bumped the version to 2.0.12.

## 0.2.8 - project-init scoped to new projects, /init handles existing ones

- Clarified the division between the `project-init` Skill and OpenCode v2's built-in `/init`: `project-init` is for brand-new or empty directories (scaffolds `AGENTS.md`, `handoff.md`, `README`, `src/`, `tests/`, `docs/` from templates), while existing projects with code and an `AGENTS.md` should use the built-in `/init`, which infers rules from the actual codebase.
- `project-init` will not overwrite an existing `AGENTS.md`; it defers to `/init` in that case.
- Documented this scope in `skills/project-init/SKILL.md`, the README Skills table and project-rules section, and `handoff.md`.
- Bumped the manifest version to 0.2.8.

## 0.2.7 - commands/ directory is version-aware

- The repo command source directory is now `commands/` (plural), matching OpenCode v2's recommendation; the singular `command/` name is retained only as the install target on OpenCode v1.x.x.
- `install.sh` / `install.ps1` pick the command install directory by detected major: v2 → `~/.config/opencode/commands/`, v1 (or undetectable) → `~/.config/opencode/command/`. An explicit second argument still overrides.
- `check.sh` / `check.ps1` verify the same version-specific directory.
- Updated `manifest/skills.json` source paths, the README structure/install sections, the `teamwork-update-check` and `config-check` Skills, and `handoff.md`.
- Bumped the manifest version to 0.2.7.

## 0.2.6 - v1-only workspace-layout and instructions

- Treat `workspace-layout` (skill) and `instructions` (command) as OpenCode v1.x.x only. On v2 the built-in `AGENTS.md` mechanism replaces them, so they are no longer installed by default.
- `install.sh` / `install.ps1` now detect the consuming OpenCode major version (`scripts/opencode-version.sh` / `opencode-version.ps1`) and skip these components when major ≥ 2.
- `check.sh` / `check.ps1` no longer require them on v2 (they still do on v1).
- `teamwork-update-check` skips `optionalOnV2` components instead of reporting them as updates.
- Marked both components `optionalOnV2: true` in `manifest/skills.json`; `FORCE=1` / `-Force` still installs them on v2.
- Documented the v1/v2 split in the README.

## 0.2.5 - /instructions command

- Renamed the companion command of the `workspace-layout` Skill from `/instruction` to `/instructions`, matching the command the team already used locally.
- Replaced the hand-written content with the team's own verification prompt: it prints only the loaded instruction file paths, one per line as a Markdown list.
- Added a conditional `設定` half: when the workspace layer is not loaded it explains the findUp/worktree bound and shows the exact `instructions` block for `~/.config/opencode/opencode.jsonc`, writing only after confirmation.
- Removed the incorrect `command/instruction.md` added in 0.2.4 and updated `manifest/skills.json`, `scripts/check.ps1`, `scripts/check.sh`, the README, and the Skill reference to `instructions`.
- Bumped the manifest version to 0.2.5.

## 0.2.4 - /instruction command

- Added the `/instruction` command as the companion of the `workspace-layout` Skill, so installing that Skill also installs the command.
- It reports which instruction files OpenCode actually loads under the real rules (project `AGENTS.md` upward search stops at the worktree; `instructions` entries are additive and never shadowed) and names the effective worktree.
- When the workspace layer is not loaded it shows the exact `instructions` block for `~/.config/opencode/opencode.jsonc`, and writes only after confirmation.
- Registered the command in `manifest/skills.json` and added it to the expected list in `scripts/check.ps1` and `scripts/check.sh`.
- Documented the loading rules in the `workspace-layout` Skill.
- Updated the README status marker and the Commands section to `v0.2.4`.

## 0.2.3 - Multi-repo workspace boundary

- Added the `workspace-layout` Skill: keeps repo boundaries in a multi-repo workspace (reads cross-repo, writes single-repo, no staging across repositories).
- It defers git command permission tiers to `git-basic` and fills the single-repo assumption in `session-start` and `session-close`.
- Registered the component in `manifest/skills.json` and added it to the expected list in `scripts/check.ps1` and `scripts/check.sh`.
- Extended `docs/STRUCTURE.md` so the "Git 基本安全習慣" scope covers multi-repo boundaries.
- Updated the README status marker and the Skills table to `v0.2.3`.

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
