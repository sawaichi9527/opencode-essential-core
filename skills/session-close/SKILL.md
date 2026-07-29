---
name: session-close
description: 結束工作階段時整理完成內容、最新驗證證據、handoff 與 Git 差異；commit 與 push 前必須詢問。
---

# Session Close

## 流程

1. 執行 `git status` 與 `git diff --stat`。
2. 依下列優先順序確認能證明本次修改的驗證方式：
   1. `AGENTS.md` 明列的命令；
   2. 專案既有 CI、README、測試設定或 Script 中的命令；
   3. 使用者在本次工作明確指定的命令；
   4. 若仍無法確定，不自行發明廣泛、破壞性或可能影響硬體的驗證。
3. 執行安全且已獲授權的驗證，讀取完整輸出與 exit code。
4. 若驗證涉及硬體控制、破壞性操作、壓力測試或長時間執行，先取得使用者同意；未執行時明確記錄原因。
5. 若本次只修改文件、設定範本或其他沒有 Runtime 行為的內容，執行適用的結構與內容檢查，並將 Runtime test 記為 `N/A`，不要為了形式啟動不相關的 DUT 或完整測試。
6. 摘要本次完成、未完成、已知問題與仍未驗證的範圍。
7. 更新 `handoff.md` 的 Validation evidence，至少記錄：
   - 實際命令或檢查方式；
   - 執行日期時間、Duration 與 exit code；
   - Pass／Fail／Skip 數量或具體觀察結果；
   - Test environment、DUT／firmware version；
   - UART／Console Log、PCAP、Report 或其他 Artifact 路徑；
   - 尚未驗證的內容。
8. 顯示預計納入 commit 的檔案。
9. 建議簡短 commit message。
10. 只有在使用者同意後才執行 `git add` 與 `git commit`。
11. `git push` 必須再次取得同意。

## 完成宣告

- 沒有本次修改後的新驗證證據，不宣稱「完成」、「已修復」或「全部通過」。
- 先前 Session、其他分支或修改前的測試結果只能作為參考，不是本次完成證據。
- 若只執行部分測試，必須明確說明其範圍，不能推論未執行的測試也會通過。
- 文件或範本檢查可以證明文件修改正確，但不能推論產品 Runtime 或 DUT 行為已驗證。

## 安全

- 發現 `.env`、Token、密碼、憑證或大型測試產物時，停止並提醒。
- 不使用 `git add -A` 隱藏未檢查的變更。
- 原始 UART Log、PCAP、JUnit 或正式報告依專案規則保存；摘要不能取代原始證據。
