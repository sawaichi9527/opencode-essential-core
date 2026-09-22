# handoff.md — OpenCode Essential Core

> 供接手 Session 閱讀的現況摘要。更新時間：2026-09-22

## 目前狀態

| 項目 | 值 |
|---|---|
| 版本 | `2.0.12`（`VERSION` / `manifest/skills.json`，與 OpenCode v2.0.12 同步） |
| 分支 | `main`（PR #4 已合併為 `1430e01`） |
| 相容性 | **僅支援 OpenCode v2.x.x**，v1 相容已於 2.0.12 移除 |

## 專案定位

OpenCode 的跨平台必要核心（Required Essential Core），與 `opencode-extension-packs`（選擇性）分離。
目標是讓小型開發團隊在 Windows、WSL、Ubuntu 與 macOS 上，對環境檢查、專案初始化、
工作階段交接、Git 基本操作與團隊基準更新採用一致做法。
Core 只保留多數使用者的共通能力，不綁定特定公司、部門或測試框架；特定審查／測試工具流程放 Extension Packs。

## 目錄結構

- `commands/` — 一個手動 command：`teamwork-update-check.md`（安裝至 `~/.config/opencode/commands/`）
- `skills/` — 八個 OpenCode 原生 Skill：
  `environment-check`、`config-check`、`project-init`、`session-start`、`session-close`、`git-basic`、`workspace-layout`、`teamwork-update-check`
  （`project-init/references/` 內含 `AGENTS.md`、`handoff.md` 範本；`project-init` 專為全新專案建立骨架，既有專案改用 v2 內建 `/init`）
- `manifest/skills.json` — 機器可讀元件清單，schemaVersion 1，version 2.0.12
- `scripts/` — `install.ps1` / `install.sh`、`check.ps1` / `check.sh`（無版本偵測，一律 v2 行為）
- `examples/`、`templates/`、`docs/` — 範例、範本與文件
- `UPSTREAM.md` — 上游來源（`mathruffian-dot/opencode-lazy-packs` 概念）與轉化說明
- `AGENTS.md` 與 `handoff.md` 範本在 `project-init/references/`，安裝單一 Skill 後仍可使用

## 最近變更（0.2.8 → 2.0.12）

1. **2.0.12（9/22）**：移除 v1 相容、改為僅支援 v2——刪除 `/instructions` command 與 `opencode-version.*` 偵測腳本、移除 manifest `optionalOnV2`；保留 `workspace-layout`（多 repo 邊界指引），其規則載入段改寫為 v2 原生做法（workspace 級規則放全域 `AGENTS.md`）。版本編號改與支援的 OpenCode 發行版同步（2.0.12）。
2. **0.2.8**：`project-init` 收斂為新建專案；既有專案改用 v2 內建 `/init`。
3. **0.2.7**：command 源目錄改複數 `commands/`，安裝路徑依偵測版本決定。
4. **0.2.6**：`workspace-layout`／`instructions` 標記 `optionalOnV2`（v1-only，2.0.12 已移除該機制）。

## 目前 Command / Skill 對應

- Eight Core Skills、one Core Command（`/teamwork-update-check`）安裝至 `~/.config/opencode/skills/` 與 `~/.config/opencode/commands/`（一律 v2 路徑）。
- `/teamwork-update-check` 讀取本 repo `main` 的 `manifest/skills.json` 與 Extension Packs 的 `manifest/packs.json` 作為更新比對來源；不由 `session-start` 自動觸發。

## 發布與驗證

- 變更流程慣例：改動時同步更新 `VERSION`、`manifest/skills.json`、`CHANGELOG.md`、README 與相關 Skill / Command 文件，再執行 `scripts/check.ps1`（Windows）或 `check.sh`（Bash）驗證八個 Skills、一個 Command 與 Project Init References。
- 三方同步慣例：本地 `main` = GitHub `origin/main` = Forgejo `forgejo/main`，任一方前進後同步其餘兩方。

## 待辦 / 注意事項

- 無已知未完成項目；推送到開源 GitHub 前先跑 secret scan。
- 若新增或有外部整合參考，同時更新 manifest 與對應文件（Core 本身不 vendored 第三方 plugin）。