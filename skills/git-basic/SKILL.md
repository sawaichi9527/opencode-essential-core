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

## 與 v2 permissions 分工

- 在 OpenCode v2，上述「可直接執行／先詢問／預設禁止」會對應並由 runtime 的 permission 系統強制：唯讀 git（`status`／`diff`／`log`／`branch`／`remote -v`／`fetch`）對應 `read`＋`bash: allow`；寫入 git（`add`／`commit`／`pull`／`push`／branch 切換）對應 `ask`；禁止項目應設為 `deny`。
- 本 Skill 補足未開細粒度權限時團隊所需的語意；若已用 v2 permissions 強制，可視情況簡化重複檢查。

GitHub 與 Forgejo 的帳號、PR/MR、MCP 與 API 整合應由 Extension Pack 處理。
