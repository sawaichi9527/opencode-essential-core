---
name: config-check
description: 檢查 OpenCode 全域與專案域設定、Skill／Command 位置、JSONC 結構與常見路徑問題，不直接覆蓋使用者設定。
---

# Config Check

## 檢查位置

- 全域設定：`~/.config/opencode/opencode.jsonc`
- 全域 Skills：`~/.config/opencode/skills/`
- 全域 Commands：`~/.config/opencode/commands/`
- 專案設定：專案根目錄的 OpenCode 設定
- 專案 Skills：`<project>/.opencode/skills/`
- 專案 Commands：`<project>/.opencode/commands/`

Windows 的 `~` 對應目前使用者家目錄，不要假設一定在 Documents。

## 檢查項目

1. 設定檔是否存在且 JSONC 結構可解析。
2. Skill 目錄名稱是否與 `SKILL.md` 的 frontmatter `name` 一致。
3. 是否存在重複或互相覆蓋的全域／專案 Skill 名稱。
4. Command 是否為 Markdown、frontmatter 是否有效，以及使用的 `agent` 是否為 OpenCode 可用 Agent。
5. 是否存在同名的全域與專案 Command；若專案 Command 覆蓋全域或 OpenCode 內建 Command，明確標示實際生效者與風險。
6. `project-init` 是否包含 `references/AGENTS.template.md` 與 `references/handoff.template.md`。
7. 是否把 Token、密碼或私鑰直接寫入設定、Skill 或 Command。
8. Windows 與 WSL 是否誤用彼此的執行檔或虛擬環境。
9. 只提出修改建議；修改前先顯示差異並取得同意。

## 輸出

使用 `OK / MISSING / SHADOWED / WARNING` 表示，並分開列出 Global 與 Project 實際生效的 Skill／Command。不要因同名覆蓋而直接刪除任一檔案。
