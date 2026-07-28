---
name: project-init
description: 在目前資料夾建立通用且精簡的 OpenCode 專案骨架，包含 AGENTS.md、handoff.md、README、src、tests 與 docs。
---

# Project Init

## 建立前

1. 顯示目前路徑。
2. 檢查是否已存在重要檔案。
3. 詢問專案名稱與一句話目的。
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

## Git

- 若尚未初始化 Git，先詢問是否執行 `git init`。
- 不自動建立遠端 Repository。
- 不自動 commit 或 push。
