---
name: config-check
description: 檢查 OpenCode 全域與專案域設定、Skill 位置、JSONC 結構與常見路徑問題，不直接覆蓋使用者設定。
---

# Config Check

## 檢查位置

- 全域設定：`~/.config/opencode/opencode.jsonc`
- 全域 Skills：`~/.config/opencode/skills/`
- 專案設定：專案根目錄的 OpenCode 設定
- 專案 Skills：`<project>/.opencode/skills/`

Windows 的 `~` 對應目前使用者家目錄，不要假設一定在 Documents。

## 檢查項目

1. 設定檔是否存在且 JSONC 結構可解析。
2. Skill 目錄名稱是否與 `SKILL.md` 的 frontmatter `name` 一致。
3. 是否存在重複或互相覆蓋的 Skill 名稱。
4. 是否把 Token、密碼或私鑰直接寫入設定。
5. Windows 與 WSL 是否誤用彼此的執行檔或虛擬環境。
6. 只提出修改建議；修改前先顯示差異並取得同意。
