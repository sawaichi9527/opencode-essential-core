# handoff.md — OpenCode Essential Core

> 供接手 Session 閱讀的現況摘要。更新時間：2026-09-18

## 目前狀態

| 項目 | 值 |
|---|---|
| 版本 | `0.2.5`（`VERSION` / `manifest/skills.json`） |
| HEAD | `7fadeac` — Rename companion command to /instructions using the team prompt (0.2.5) |
| 三方同步 | 本地 `main` = GitHub `origin/main` = Forgejo `forgejo/main` = `7fadeac` |
| working tree | clean，無未提交變更 |

## 專案定位

OpenCode 的跨平台必要核心（Required Essential Core），與 `opencode-extension-packs`（選擇性）分離。
目標是讓小型開發團隊在 Windows、WSL、Ubuntu 與 macOS 上，對環境檢查、專案初始化、
工作階段交接、Git 基本操作與團隊基準更新採用一致做法。
Core 只保留多數使用者的共通能力，不綁定特定公司、部門或測試框架；特定審查／測試工具流程放 Extension Packs。

## 目錄結構

- `command/` — 兩個手動 command：`teamwork-update-check.md`、`instructions.md`
- `skills/` — 八個 OpenCode 原生 Skill：
  `environment-check`、`config-check`、`project-init`、`session-start`、`session-close`、`git-basic`、`workspace-layout`、`teamwork-update-check`
  （`project-init/references/` 內含 `AGENTS.md`、`handoff.md` 範本）
- `manifest/skills.json` — 機器可讀元件清單，schemaVersion 1，version 0.2.5
- `scripts/` — `install.ps1` / `install.sh`、`check.ps1` / `check.sh`
- `examples/`、`templates/`、`docs/` — 範例、範本與文件
- `UPSTREAM.md` — 上游來源（`mathruffian-dot/opencode-lazy-packs` 概念）與轉化說明
- `AGENTS.md` 與 `handoff.md` 範本在 `project-init/references/`，安裝單一 Skill 後仍可使用

## 最近變更（0.2.2 → 0.2.5）

1. **0.2.5（9/16）**：`/instruction` → `/instructions`，以團隊實際使用的 command 為準；改為列印已載入 instruction 檔案路徑，並在 workspace 層未載入時顯示 `instructions` 設定塊（確認後才寫入）。
2. **0.2.4（9/16）**：新增 `/instruction` command 作為 `workspace-layout` 的搭配；刪除前版錯誤內容。
3. **0.2.3（9/16）**：新增 `workspace-layout` Skill——多 repo workspace 的層級判斷與 repo 邊界（讀可跨、寫單一 repo，不跨 repo staging）；git 權限沿用 `git-basic`。
4. **0.2.2**：新增 `manifest/skills.json`；`teamwork-update-check` 改讀兩個 repository 的 manifest，比對本機安裝基準，確認後才套用。

## 目前 Command / Skill 對應

- Eight Core Skills、two Core Commands（`/teamwork-update-check`、`/instructions`）安裝至 `~/.config/opencode/skills/` 與 `~/.config/opencode/command/`。
- `/teamwork-update-check` 讀取本 repo `main` 的 `manifest/skills.json` 與 Extension Packs 的 `manifest/packs.json` 作為更新比對來源；不由 `session-start` 自動觸發。

## 發布與驗證

- 變更流程慣例：改動時同步更新 `VERSION`、`manifest/skills.json`、`CHANGELOG.md`、README 與相關 Skill / Command 文件，再執行 `scripts/check.ps1`（Windows）或 `check.sh`（Bash）驗證八個 Skills、兩個 Commands 與 Project Init References。
- 三方同步慣例：本地 `main` = GitHub `origin/main` = Forgejo `forgejo/main`，任一方前進後同步其餘兩方。

## 待辦 / 注意事項

- 無已知未完成項目；推送到開源 GitHub 前先跑 secret scan。
- 若新增或有外部整合參考，同時更新 manifest 與對應文件（Core 本身不 vendored 第三方 plugin）。