---
name: git-basic
description: 以小型團隊可理解的方式執行本地 Git 基本操作；安全讀取可直接執行，寫入、同步與破壞性操作需確認。
---

# Git Basic

## 可直接執行

- `git status`
- `git diff`
- `git log`
- `git branch`
- `git remote -v`（輸出前移除可能的 credential）
- `git fetch`

## 先顯示內容再詢問

- `git add`
- `git commit`
- `git pull`
- `git push`
- branch 切換或建立

## 預設禁止

- `git reset --hard`
- `git clean -fd`
- 強制 push
- 未確認的大量刪除

GitHub 與 Forgejo 的帳號、PR/MR、MCP 與 API 整合應由 Extension Pack 處理。
