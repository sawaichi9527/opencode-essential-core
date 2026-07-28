---
name: session-close
description: 結束工作階段時摘要完成內容、更新 handoff、顯示 Git 差異並建議 commit message；push 前必須詢問。
---

# Session Close

## 流程

1. 執行 `git status` 與 `git diff --stat`。
2. 摘要本次完成、未完成、驗證結果與已知問題。
3. 更新 `handoff.md`，保留可讓下一位開發者接續的資訊。
4. 顯示預計納入 commit 的檔案。
5. 建議簡短 commit message。
6. 只有在使用者同意後才執行 `git add` 與 `git commit`。
7. `git push` 必須再次取得同意。

## 安全

- 發現 `.env`、Token、密碼、憑證或大型測試產物時，停止並提醒。
- 不使用 `git add -A` 隱藏未檢查的變更。
