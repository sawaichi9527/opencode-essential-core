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

## 規則載入

v2 的規則載入順序（來源：[Instructions](https://opencode.ai/v2/docs/instructions/)）：先載入全域檔，再從目前工作目錄**朝 home 方向**一路往上，把路徑上的 `AGENTS.md` **全部合併**。

- 全域檔：`~/.config/opencode/AGENTS.md`（永遠載入）。
- 專案鏈：從 cwd 往上到 home 之間的所有 `AGENTS.md` 都會載入（最近的優先，之後再補上較上層的）。
- 若工作區在 **home 目錄之外**，向上搜尋止於 project root。
- 若 cwd 在 project root **之外**，只載入全域檔。
- v2 **只認 `AGENTS.md`**，不把 `CLAUDE.md` 當備援。
- OpenCode 會把這些檔案**合併**，不會在衝突時取捨或讓某個檔案「勝出」。

因此多 repo workspace（例如 `~/workspace/<專案>/`）開 session 時，workspace 根的 `AGENTS.md` 通常**會被載入**；只有當工作區在 home 外、或 cwd 落在 project root 之外時，上層規則才不會被載入。

處理方式（由使用者選擇，不自動改設定）：

1. 先確認目前 session 實際載入了哪些 `AGENTS.md`（v2 會自動載入全域與專案檔，直接確認即可，不需要額外指令）；
2. workspace 層規則若為**所有專案共通**，放入全域 `~/.config/opencode/AGENTS.md`（全域優先載入，不會被專案檔取代）；
3. 若只與**單一專案**相關，直接寫進該專案的 `AGENTS.md`；
4. 修改設定檔前顯示差異並取得使用者確認，寫入後驗證 JSONC 可解析。

## 動工前：先判斷層級

1. 先執行 `git rev-parse --show-toplevel`，確認「這次操作屬於哪個 repo」。**不要用 cwd 猜測。**
2. 若同時存在 workspace 根與專案的 `AGENTS.md`，兩者並存、不互相取代。
3. 讀取 workspace 的專案清單（例如 `WORKSPACE.md`），確認專案、遠端與 owner。
4. 若某專案主要由其他機器開發，先確認這次修改應該做在哪一台；在本機改了卻沒推回共用遠端，等於沒人知道。

## 硬規則

1. **Writes single-repo**：一次寫入只針對一個 repo；一次 commit 只能屬於一個 repo。
2. **Reads cross-repo**：唯讀可跨專案查閱（grep、讀檔、比對）。注意 v2 預設對目前 Location 與 project worktree 之外的路徑要求 `external_directory` 批准（`external_directory: *` 預設為 `ask`）；跨 repo 查閱時若被要求批准，可對 workspace 根下的兄弟 repo 路徑在 `opencode.jsonc` 加 `external_directory: allow`（例如 `{ "action": "external_directory", "resource": "<workspace>/projects/*", "effect": "allow" }`），或逐次批准。
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
