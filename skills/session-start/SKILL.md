---
name: session-start
description: 開始工作階段時讀取專案規則、交接紀錄與 Git 狀態，整理本次應優先處理的事項；預設只讀。
---

# Session Start

## 流程

1. 確認目前專案根目錄。
2. 讀取 `AGENTS.md`。
3. 讀取 `handoff.md`。
4. 執行 `git status --short --branch`。
5. 必要時執行 `git log -5 --oneline`。
6. 整理：
   - 專案目的
   - 尚未完成事項
   - 工作目錄是否乾淨
   - 建議的下一步

## 限制

- 不自動 `git pull`。
- 不修改檔案。
- 不啟動長時間服務。
