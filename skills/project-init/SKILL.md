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

## 內建範本

本 Skill 安裝後應同時包含：

```text
skills/project-init/
├── SKILL.md
└── references/
    ├── AGENTS.template.md
    └── handoff.template.md
```

- 若沒有 `AGENTS.md`，使用本 Skill 相對路徑 `references/AGENTS.template.md` 作為起點。
- 若沒有 `handoff.md`，使用本 Skill 相對路徑 `references/handoff.template.md` 作為起點。
- 不依賴 Repository 根目錄或安裝後不存在的外部 Template 路徑。
- 建立前先顯示預計產生的檔案；只有使用者同意後才寫入。

## OpenCode 專案規則

- `AGENTS.md` 是本專案給 OpenCode 的共用規則，應跟著專案提交到 Git。
- 只保留專案目的、工作規則、驗證指令與必要限制，避免把長篇教學或所有文件塞入其中。
- 依實際專案替換範本中的 Purpose、Validation 與 Project-specific notes，不保留無關範例。
- 除非使用者明確要求，不建立 `CLAUDE.md`、Cursor Rules、Codex Plugin、Hook 或其他 Agent 專用設定。

## Git

- 若尚未初始化 Git，先詢問是否執行 `git init`。
- 不自動建立遠端 Repository。
- 不自動 commit 或 push。
