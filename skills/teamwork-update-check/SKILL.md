---
name: teamwork-update-check
description: 手動檢查 sawaichi9527 的 OpenCode Core 與 Extension Packs 更新，比對 skill/plugin 版本，整理差異並在套用前取得使用者確認；不由 session-start 自動觸發。
---

# Teamwork Update Check

## 目的

只在使用者明確執行 `/teamwork-update-check` 或提出等價要求時，檢查團隊 OpenCode 基準的更新。這不是 OpenCode 內建更新器，也不是背景排程。對先前已安裝的使用者，本流程會比對已安裝的 skill / plugin 版本與最新發布版本，通知差異並詢問是否升級變動的版本。

## 固定查詢來源（Read-only）

以各 repository 的 `main` 分支為「已發布最新」的規範來源。優先直接讀取下列檔案：

- Core manifest: `https://raw.githubusercontent.com/sawaichi9527/opencode-essential-core/main/manifest/skills.json`
- Core VERSION: `https://raw.githubusercontent.com/sawaichi9527/opencode-essential-core/main/VERSION`
- Extension Packs manifest: `https://raw.githubusercontent.com/sawaichi9527/opencode-extension-packs/main/manifest/packs.json`
- Extension Packs VERSION: `https://raw.githubusercontent.com/sawaichi9527/opencode-extension-packs/main/VERSION`
- 兩個 repository 的 `CHANGELOG.md`（同式 raw 網址）

使用 GitHub MCP 或其他可驗證的唯讀來源讀取。不要把目前工作目錄的未提交內容當成遠端最新版本。需要判斷「最新 commit」時，用 GitHub API 取得 `main` 的最新 commit SHA。若 raw 網址無法存取，改用 GitHub MCP 讀取同路徑檔案。

## 檢查流程

1. 讀取兩個 repository 的 `VERSION`、`manifest/*.json`、`CHANGELOG.md` 與 README。
2. 讀取本機安裝基準；優先檢查：
   - `~/.config/opencode/teamwork-install-state.json`
   - 全域 Skills、Commands 與 `opencode.jsonc`
   - 專案 `.opencode/skills/` 與 `.opencode/commands/`
3. 若沒有安裝基準：視為首次安裝。依 Extension Packs manifest 列出 `default`、`recommended`、`optional` 三層 Pack，並顯示 Pack 的 `category`（`category: other` 不視為新的 tier）。將 `defaultPacks` 標為建議預選，但仍詢問使用者。
4. 若已有安裝基準：依「版本比對規則」計算 Core 與 Extension Packs 的差異，包括已安裝 skill 與已選 plugin 的版本更新。
5. 依「通知與升級詢問」呈現差異並取得確認；套用後更新安裝基準。

## 版本比對規則

比對項目與分類：

- 每個 repository 的 `version`（`VERSION` 檔與 manifest 一致才算發布完成）與 `main` commit。
- Core：以 `manifest/skills.json` 的 `components` 比對已安裝 skills / commands：
  - 最新 manifest 新增且本機未安裝 → `ADDED`
  - 已安裝但已不在最新 manifest → `REMOVED`
  - `id + kind` 相同但 `sourcePath` 改變 → `CHANGED`
- Extension Packs：以 `manifest/packs.json` 比對已選 Packs：
  - Pack 的 `tier`、`kind`、`audience`、`sourcePath` 改變 → `CHANGED`
  - 已選外部 plugin（如 `ppt-master`、`playwright-mcp`、`codebase-memory-mcp`、`token-usage`）的固定版本改變 → `CHANGED`（plugin 版本更新）
  - 新增或移除的 Pack → `ADDED` / `REMOVED`
- CHANGELOG 描述的行為、設定或安裝流程變更 → `COMPATIBILITY`
- 本機檔案與發布不同 → `LOCAL CONFLICT`，不要覆蓋

plugin 版本更新的判讀：比較最新 manifest 中該 Pack 的 `release` 或 `package` 欄位，與本機安裝基準記錄的固定版本。兩者不同即代表有可用的 plugin 版本更新。

## 版本要求

Core 僅支援 OpenCode v2.x.x。若本機 OpenCode major < 2 或無法確認，在差異報告中標示 `COMPATIBILITY`，提醒本套件不適用於該版本；不要因此停用唯讀檢查。

## Baseline 建議格式（schemaVersion 2）

```json
{
  "schemaVersion": 2,
  "core": {
    "source": "https://github.com/sawaichi9527/opencode-essential-core",
    "version": "0.2.2",
    "commit": "<verified commit>",
    "skills": {
      "environment-check": "skills/environment-check",
      "config-check": "skills/config-check",
      "project-init": "skills/project-init",
      "session-start": "skills/session-start",
      "session-close": "skills/session-close",
      "git-basic": "skills/git-basic",
      "workspace-layout": "skills/workspace-layout",
      "teamwork-update-check": "skills/teamwork-update-check"
    },
    "commands": {
      "teamwork-update-check": "commands/teamwork-update-check.md"
    }
  },
  "extensionPacks": {
    "source": "https://github.com/sawaichi9527/opencode-extension-packs",
    "version": "0.2.4",
    "commit": "<verified commit>",
    "selected": [],
    "plugins": {
      "ppt-master": "v6.4.0",
      "playwright-mcp": "@playwright/mcp@0.0.81",
      "codebase-memory-mcp": "codebase-memory-mcp@0.11.0",
      "token-usage": "@ramtinj95/opencode-tokenscope@1.8.1"
    }
  }
}
```

`schemaVersion` 1 的舊基準可沿用：升級時以目前安裝的 components 與已選 plugin 的固定版本填補新欄位。不要把 access token 或私人 URL 寫入此檔案。

commands 路徑固定記錄為 `commands/<name>.md`（OpenCode v2 的複數目錄）。若舊基準記錄的是 v1 的 `command/<name>.md`，升級時改為 `commands/`；此類僅因目錄名而異的差異視為正常而非 `CHANGED`。

## 通知與升級詢問

1. 先顯示：檢查時間、兩個來源、本機基準狀態、Core 差異、Extension Packs 差異、plugin 版本差異、相容性與本機衝突。
2. 對每個變動版本顯示：項目、目前版本 → 最新版本、來源 URL、CHANGELOG / compatibility 摘要。
3. 最後才詢問使用者要套用哪些升級。提供以下選項：
   - 全部升級
   - 只升級 Core，或個別 Pack / plugin
   - 暫不升級
4. 未獲得明確同意前：不修改檔案、不執行 `npm install -g`、不更新 `opencode.jsonc`、不執行 `git pull`。
5. 套用後：重新驗證（Core 的 `scripts/check.ps1` / `check.sh`、各 Pack 的 Installation Checks），再更新安裝基準為新的 commit 與版本。
6. 若沒有更新，明確說明未發現可套用差異，不建立背景排程。

## 套用規則

- 只讀檢查完成後，才詢問使用者是否套用。
- 使用者可以選擇只套用 Core、只套用指定 Pack，或暫不套用。
- 首次安裝時，使用者可從 manifest 清單選擇 Default、Recommended 與 Optional Pack；不因 `defaultPacks` 而跳過確認。
- 本機檔案若與遠端版本不同，先列為 `LOCAL CONFLICT`，不要覆蓋。
- 套用前提供將被修改的檔案、版本與來源；套用後重新驗證並更新安裝基準。
- 合併設定時保留不相關的 providers、plugins、MCP servers 與使用者特定值。
- 不保存 token、密碼、私鑰或其他秘密到安裝基準。

## 輸出格式

先顯示：

- 檢查時間與兩個來源
- 本機 baseline 狀態
- 首次安裝時的三層 Pack 選擇清單，或既有安裝的差異（含 plugin 固定版本差異）
- Core 差異
- Extension Packs 差異
- 相容性與本機衝突

最後才詢問使用者要套用哪些變更。若沒有更新，明確說明未發現可套用差異，不需要建立背景排程。