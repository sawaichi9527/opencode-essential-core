---
name: session-start
description: 開始工作階段時讀取專案規則、交接紀錄與 Git 狀態，整理本次應優先處理的事項；預設只讀。
---

# Session Start

## 流程

1. 確認目前專案根目錄。
2. 確認專案規則已載入：v2 會自動載入工作區的 `AGENTS.md`；若專案有多層 `AGENTS.md`（例如 `packages/` 下另有規範），確認當前工作區版本已在 context 中。
3. 讀取 `handoff.md`。
4. 執行 `git status --short --branch`。
5. 必要時執行 `git log -5 --oneline`。
6. 整理：
   - 專案目的
   - 尚未完成事項
   - 工作目錄是否乾淨
   - 建議的下一步

## 備註

- v2 會持久化 session：以 `opencode --continue`（或 `-c`）接續上次、`--fork` 分叉接續，前次 session 的完整對話原本即可取得。
- `handoff.md` 是結構化交接（含驗證證據），與 v2 自動產生的 session summary 互補；仍以它作為本次優先事項來源。

## 限制

- 不自動 `git pull`。
- 不修改檔案。
- 不啟動長時間服務。
