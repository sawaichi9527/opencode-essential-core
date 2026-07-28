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
   - `opencode`
   - `git`
   - `node`
   - `npm`
   - `python` 或 `python3`
   - `uv`
4. 若位於 Git Repository，顯示工作目錄與 remote；不要輸出 credential。
5. 不自動執行套件安裝、不要求管理員權限、不修改 PATH。
6. 結果使用 `OK / MISSING / OPTIONAL / WARNING` 表示。

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
- 不把內部 Server URL 上傳到外部服務。
