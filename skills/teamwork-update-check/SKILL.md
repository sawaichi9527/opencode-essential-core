---
name: teamwork-update-check
description: 手動檢查 sawaichi9527 的 OpenCode Core 與 Extension Packs 更新，整理差異並在套用前取得使用者確認；不由 session-start 自動觸發。
---

# Teamwork Update Check

## 目的

只在使用者明確執行 `/teamwork-update-check` 或提出等價要求時，檢查團隊 OpenCode 基準的更新。這不是 OpenCode 內建更新器，也不是背景排程。

## 固定來源

- Core: `https://github.com/sawaichi9527/opencode-essential-core`
- Extension Packs: `https://github.com/sawaichi9527/opencode-extension-packs`

使用 GitHub MCP 或其他可驗證的唯讀來源讀取兩個 repository。不要把目前工作目錄的未提交內容當成遠端最新版本。

## 檢查流程

1. 讀取兩個 repository 的 `VERSION`、`CHANGELOG.md`、README 與相關 manifest。
2. 讀取本機安裝基準；優先檢查：
   - `~/.config/opencode/teamwork-install-state.json`
   - 全域 Skills、Commands 與 `opencode.jsonc`
   - 專案 `.opencode/skills/` 與 `.opencode/command/`
3. 若沒有安裝基準：
   - 明確標示目前是未建立 baseline。
   - 依 Extension Packs manifest 列出 `default`、`recommended`、`optional` 三層 Pack。
   - 將 `defaultPacks` 標為建議預選，但仍在任何安裝前詢問使用者。
   - 對 `recommended` 與 `optional` 不預選，只等待使用者主動選擇。
4. 若已有 baseline，先比對版本與 commit，再找出上次 baseline 之後的變更。
5. 比對：
   - repository 版本與 commit
   - 新增、修改、移除的 Skill 與 Command
   - Extension Pack 的 tier、依賴、來源與版本
   - OpenCode、Node.js、npm 或外部套件相容性要求
   - CHANGELOG 所描述的行為、設定與安裝流程變更
6. 以 `ADDED / CHANGED / REMOVED / COMPATIBILITY / LOCAL CONFLICT` 分類輸出摘要。
7. 對外部 plugin、npm 套件、命令檔與設定檔分開列出影響範圍。

## 套用規則

- 只讀檢查完成後，才詢問使用者是否套用。
- 未獲得明確同意前，不修改檔案、不安裝 npm 套件、不更新 `opencode.jsonc`、不執行 `git pull`。
- 使用者可以選擇只套用 Core、只套用指定 Pack，或暫不套用。
- 首次安裝時，使用者可從 manifest 清單選擇 Default、Recommended 與 Optional Pack；不因 `defaultPacks` 而跳過確認。
- 本機檔案若與遠端版本不同，先列為 `LOCAL CONFLICT`，不要覆蓋。
- 套用前提供將被修改的檔案、版本與來源；套用後重新驗證並更新安裝基準。
- 不保存 token、密碼、私鑰或其他秘密到安裝基準。

## Baseline 建議格式

若使用者同意建立或更新 baseline，使用者家目錄下的狀態檔可採用以下欄位：

```json
{
  "schemaVersion": 1,
  "core": {
    "source": "https://github.com/sawaichi9527/opencode-essential-core",
    "version": "0.0.1",
    "commit": "<verified commit>"
  },
  "extensionPacks": {
    "source": "https://github.com/sawaichi9527/opencode-extension-packs",
    "version": "0.0.1",
    "commit": "<verified commit>",
    "selected": []
  }
}
```

不要把 access token 或私人 URL 寫入此檔案。

## 輸出格式

先顯示：

- 檢查時間與兩個來源
- 本機 baseline 狀態
- 首次安裝時的三層 Pack 選擇清單，或既有安裝的差異
- Core 差異
- Extension Packs 差異
- 相容性與本機衝突

最後才詢問使用者要套用哪些變更。若沒有更新，明確說明未發現可套用差異，不需要建立背景排程。
