---
name: environment-check
description: 跨平台檢查 OpenCode、Git、Node.js、Python、uv、Shell 與目前專案環境；只回報狀態，不自動安裝或修改系統。
---

# Environment Check

## 目的

快速回答「這台電腦目前能不能開始進行 OpenCode 開發」。

## 執行原則

1. 先判斷執行平台：Windows、WSL、Linux 或 macOS。
2. 檢查目前 Shell。
3. 檢查下列指令是否存在並顯示版本：
   - `opencode`（用 `opencode --version` 顯示版本）
   - `git`
   - `node`
   - `npm`
   - `python` 或 `python3`
   - `uv`
4. 檢查開發所需的 provider／憑證是否就緒（v2）：執行 `opencode auth ls` 確認已登入的 provider；若沒有任何可用 provider，標示 `WARNING`。
5. 若位於 Git Repository，顯示工作目錄與 remote；不要輸出 credential。
6. 不自動執行套件安裝、不要求管理員權限、不修改 PATH。
7. 結果使用 `OK / MISSING / OPTIONAL / WARNING` 表示。

## 建議輸出

```text
Platform: Windows 11 / PowerShell
OpenCode: OK
Git: OK
Node.js: OPTIONAL - missing
Python: OK
uv: MISSING
Git repository: YES
Remote: Forgejo / GitHub / Other
```

## 安全

- 不讀取或輸出 Token、密碼、`.env` 內容。
- `opencode auth ls`／`models` 只顯示 provider 名稱與狀態，不輸出 API key 或完整 token。
- 不把內部 Server URL 上傳到外部服務。
