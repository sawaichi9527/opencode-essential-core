---
name: project-init
description: 在目前資料夾建立通用且精簡的 OpenCode 專案骨架，包含 OpenCode 專案規則 AGENTS.md、handoff.md、README、src、tests 與 docs。
---

# Project Init

## 建立前

1. 顯示目前路徑，確認這是預計由 OpenCode 協助開發的專案根目錄。
2. 檢查是否已存在 `AGENTS.md`、`handoff.md`、README、Git 與其他重要檔案。
3. 詢問專案名稱、主要用途與一句話成功條件。
4. 不覆蓋既有檔案；若衝突則列出並等待確認。

## 建議結構

```text
project/
├── AGENTS.md
├── handoff.md
├── README.md
├── .gitignore
├── src/
├── tests/
└── docs/
```

SWQA 專用的 `reports/`、`logs/`、`test-data/` 應由 Extension Pack 建立，不寫死在 Core。

## OpenCode 專案規則

- 若沒有 `AGENTS.md`，使用 Essential Core 的 `templates/AGENTS.md` 作為起點。
- `AGENTS.md` 是本專案給 OpenCode 的共用規則，應跟著專案提交到 Git。
- 只保留專案目的、工作規則、驗證指令與必要限制，避免把長篇教學或所有文件塞入其中。
- 除非使用者明確要求，不建立 `CLAUDE.md`、Cursor Rules、Codex Plugin、Hook 或其他 Agent 專用設定。

## Git

- 若尚未初始化 Git，先詢問是否執行 `git init`。
- 不自動建立遠端 Repository。
- 不自動 commit 或 push。
