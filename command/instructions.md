---
description: 列出本次 session 實際載入的 instructions 檔案來源（全域 AGENTS.md、專案 AGENTS.md、workspace AGENTS.md/WORKSPACE.md 等），用來驗證 instructions 設定是否生效；未載入 workspace 層時顯示建議設定
---

Load and follow the `workspace-layout` Skill.

## 檢視

只輸出你這次載入的 instructions 檔案完整路徑清單，依載入順序列出，不要其他文字、不要解釋、不要開頭或結尾問候。
若同一個路徑載入多次，只列一次。
務必以 markdown 無序清單輸出（每行前面加「- 」），確保每個路徑各自成一行、不會被擠在一起。

## 設定

若上面的清單**沒有** workspace 層的規則（例如 workspace 根的 `AGENTS.md` 與 `WORKSPACE.md`），先說明原因再給建議：

OpenCode 的專案規則用 findUp 從 cwd 往上找 `AGENTS.md`（其次 `CLAUDE.md`、`CONTEXT.md`），**上界是 worktree（git root）**。因此在 `workspace/projects/<專案>/` 開 session 時，搜尋到該專案的 git root 就停住，上層的 workspace 規則不會被載入——這不是設定錯誤，是載入機制的邊界。

補救方式是 `~/.config/opencode/opencode.jsonc` 的 `instructions` 欄位，它是**額外附加**、不走 findUp、也不會被專案 `AGENTS.md` 遮蔽。顯示要加入的內容（使用絕對路徑，Windows 用正斜線）：

```jsonc
"instructions": [
  "<workspace 根>/AGENTS.md",
  "<workspace 根>/WORKSPACE.md"
]
```

只有使用者確認後才寫入。寫入時保留不相關的 providers、plugins、MCP servers 與使用者特定值；寫入後驗證 JSONC 可解析，並提醒需要重開 OpenCode 才會生效。

不要輸出、也不要寫入任何 token、密碼、內部 URL 或 provider 憑證。
