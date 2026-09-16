---
name: workspace-layout
description: 在一個目錄下存在多個各自獨立 repo 的 workspace 中，判斷目前位於 workspace 根、專案或巢狀 clone，強制 repo 邊界與單一 repo 寫入；git 指令權限沿用 git-basic。
---

# Workspace Layout

## 目的

處理「一個目錄下有多個各自獨立的 Git repo」的佈局與邊界。

適用情境：本機有一個 workspace 根目錄，其下每個專案各自是獨立的 Git repo（有無遠端皆同）；根目錄本身也可能是一個只擁有「全域級」檔案的薄 repo。

不處理：單一 repo 內的目錄結構。

git 指令本身的權限分級（哪些可直接執行、哪些要先確認、哪些禁止）一律沿用 Essential Core 的 `git-basic`，本 Skill **不重述**。

## 三層權責

| 層 | 內容 | 擁有者 |
|---|---|---|
| workspace 根 | 全域級文件、workspace 規則、專案清單 | 根層 repo（可為純本機、無遠端） |
| 專案 | 該專案的原始碼與文件 | 該專案自己的 repo |
| 工具與暫存 | 工具輸出、套件快取、暫存殘留 | 不納版控，由根層忽略 |

與本 Skill 相關的常見缺口：`session-start` 的「確認目前專案根目錄」與 `session-close` 的 commit 流程都是**單一 repo 視角**，在多 repo workspace 中不會自動帶入上層資訊，需要本 Skill 補上。

## 規則載入與 `/instruction`

本 Skill 隨附 `/instruction` command，處理「上層規則沒有被載入」這個結構性問題。

OpenCode 的專案規則搜尋會從 cwd 往上找 `AGENTS.md`（其次 `CLAUDE.md`、`CONTEXT.md`），但**上界是 worktree（git root）**。因此在 `workspace/projects/<專案>/` 開 session 時，專案的 `AGENTS.md` 會勝出，**workspace 根的規則永遠不會被載入**。

補救方式是 `~/.config/opencode/opencode.jsonc` 的 `instructions` 欄位：它是**額外附加**、不走向上的搜尋、也不會被專案 `AGENTS.md` 遮蔽。

`/instruction` 會：

1. 依上述規則列出目前**實際載入**的 instruction 來源，並標明生效的 `worktree`；
2. 若 workspace 層未被納入，顯示建議加入 `instructions` 的內容（workspace 根的 `AGENTS.md` 與 `WORKSPACE.md`）；
3. 只有使用者確認後才寫入 `opencode.jsonc`，並在寫入後驗證 JSONC。

## 動工前：先判斷層級

1. 先執行 `git rev-parse --show-toplevel`，確認「這次操作屬於哪個 repo」。**不要用 cwd 猜測。**
2. 若同時存在 workspace 根與專案的 `AGENTS.md`，兩者並存、不互相取代。
3. 讀取 workspace 的專案清單（例如 `WORKSPACE.md`），確認專案、遠端與 owner。
4. 若某專案主要由其他機器開發，先確認這次修改應該做在哪一台；在本機改了卻沒推回共用遠端，等於沒人知道。

## 硬規則

1. **Writes single-repo**：一次寫入只針對一個 repo；一次 commit 只能屬於一個 repo。
2. **Reads cross-repo**：唯讀可跨專案查閱（grep、讀檔、比對），不受限制。
3. 一律使用 `git -C <repo>`；不要在 A 目錄對 B repo 下 git 指令。
4. **禁止跨 repo `git add`**。不要用 `git add -A` 或 `git add .` 從上層掃描。
5. 不要為了方便而在巢狀位置再 `git init` 一層（例如在專案外層多包一層 repo）。
6. 不要把環境或部署目標寫進目錄名；那是清單的資料，不是路徑的一部分。
7. 被全域設定引用的檔案（MCP server、script）不得放在任何專案 working tree 內；分支切換會讓它消失。

## 跨 repo 變更流程

1. 先確認哪些 repo 需要改，以及它們在清單中的關係。
2. 從「擁有介面／來源」的 repo 開始，再往下游改。
3. 每個 repo 各自 stage、各自 commit，訊息符合該 repo 的歷史風格。
4. 推送前逐 repo 確認遠端與分支。
5. 回報時**分開**列出每個 repo 的變更，不要混成一個摘要。

## 檢查清單

動 git 前逐項確認：

- `git rev-parse --show-toplevel` 是預期的 repo
- 這次只會 stage 這一個 repo 的檔案
- 沒有把上層 workspace 的檔案混進專案 commit
- 沒有把專案檔案混進根層 commit
- 大型產物、快取與暫存目錄沒有被納入

## 輸出

分開列出：

- 目前層級（workspace 根 / 專案 / 巢狀 clone）
- 涉及的 repo 與各自的 toplevel
- 每個 repo 的變更與 commit
- 未處理或需要使用者決定的部分
