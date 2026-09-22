# OpenCode Essential Core

OpenCode 的跨平台必要核心，目標是讓小型開發團隊在 Windows、WSL、Ubuntu 與 macOS 上，
對環境檢查、專案初始化、工作階段交接、Git 基本操作與團隊基準更新採用一致做法。

本專案以 SWQA 自動化開發作為主要驗證場景，但核心內容不綁定公司、部門或特定測試框架，
也可供 SWRD 與個人專案使用。

> 狀態：v0.2.8。內容源自
> `mathruffian-dot/opencode-lazy-packs` 的概念，並參考成熟的 AI Coding 精簡修改與驗證原則，
> 但只保留適合 OpenCode 小型團隊使用的部分。

## OpenCode 使用邊界

本 Repository 專門服務 OpenCode 開發流程，主要使用 OpenCode 原生機制：

```text
AGENTS.md                    專案共用規則
.opencode/skills/            專案限定 Skills
~/.config/opencode/skills/   全域共用 Skills
.opencode/commands/          專案限定 Commands（v2）；v1 為 `.opencode/command/`
~/.config/opencode/commands/ 全域共用 Commands（v2）；v1 為 `~/.config/opencode/command/`
opencode.jsonc               OpenCode 設定與權限
```

不會自動建立或安裝 Claude Code Plugin、Codex Plugin、Cursor Rules、跨 Agent Hook 或模式狀態管理。

## 設計原則

- Core 只保留多數 OpenCode 使用者都需要的能力。
- 常駐的程式修改準則保持精簡，放在專案 `AGENTS.md`，並跟著專案提交到 Git。
- 特定審查或工具流程使用 OpenCode Skill 按需載入，不在每輪對話注入大量規則。
- 不在 Core 內綁定 GitHub、Forgejo、NotebookLM、Supabase 或其他特定服務。
- 不把 Windows、Linux 與 macOS 拆成多套不同 Harness。
- 危險 Git 操作、push 與破壞性檔案操作必須先詢問。
- 不在 Repository、設定、Skill 或 Command 範本中保存 Token、密碼或內部 URL。
- 沒有本次修改後的新驗證證據，不宣稱工作已完成、修復或通過。
- 團隊基準更新只在使用者明確執行 `/teamwork-update-check` 後檢查，不建立背景排程或自動覆蓋。

## 目前包含的 Skills

| Skill | 中文用途 |
|---|---|
| `environment-check` | 檢查 OpenCode、Git、Node.js、Python/uv 與執行平台 |
| `config-check` | 檢查全域與專案域 OpenCode 設定、Skills、Commands 與路徑覆蓋 |
| `project-init` | 為全新/空資料夾建立基本專案骨架（`AGENTS.md`、`handoff.md`、`README`、`src/tests/docs`）；既有專案請改用 v2 內建 `/init` |
| `session-start` | 開始工作前讀取規則、交接與 Git 狀態 |
| `session-close` | 整理本次工作、最新驗證證據、交接與 Git 變更 |
| `git-basic` | 統一安全且可理解的本地 Git 操作 |
| `workspace-layout` | 多 repo workspace 的層級判斷與 repo 邊界（讀可跨、寫單一 repo）；隨附 `/instructions` command（**v1-only**） |
| `teamwork-update-check` | 手動比對團隊 Core 與 Extension Packs repository 的版本與變更，套用前詢問使用者 |

## Commands

Core 提供兩個手動 command：

```text
/teamwork-update-check
/instructions
```

`/teamwork-update-check` 會讀取 `sawaichi9527/opencode-essential-core` 與 `sawaichi9527/opencode-extension-packs` 發布的
`manifest/skills.json` 與 `manifest/packs.json`（含外部 plugin 固定版本），比對本機安裝基準
（`~/.config/opencode/teamwork-install-state.json`），找出 skill / plugin 版本更新、
新增與移除的元件、CHANGELOG 與相容性要求，通知差異並在確認後才升級。
它不會由 `session-start` 自動觸發，也不會在未獲得確認前修改本機設定或安裝套件。

`/instructions` 是 `workspace-layout` Skill 的搭配 command，與該 Skill 一起安裝（**僅限 OpenCode v1.x.x**）。它會依 OpenCode
實際的載入規則列出目前生效的 instruction 來源——專案 `AGENTS.md` 由 cwd 往上搜尋但**上界是
worktree（git root）**，而 `instructions` 欄位是額外附加、不被專案 `AGENTS.md` 遮蔽——並標明生效的
`worktree`。若上層 workspace 規則未被載入，它會顯示要加入 `~/.config/opencode/opencode.jsonc`
的 `instructions` 內容，確認後才寫入並重新驗證 JSONC。

Extension Packs 的 `hybrid-workflow` 屬於 `category: other` 的 workflow，包含泛用
`workflow_local_builder`、team 28500 專用的 `workflow_local_builder_aeon`，以及導入時選擇雲端模型的
`workflow_cloud_cheap_builder`。Core 只列出並檢查這些資訊，不依賴任何特定 provider、GPU 或 Extension Pack。

## Repository 結構

```text
opencode-essential-core/
├── commands/
│   ├── teamwork-update-check.md
│   └── instructions.md
├── skills/
│   ├── teamwork-update-check/
│   └── project-init/
│       └── references/
├── manifest/
│   └── skills.json
├── scripts/
├── examples/
└── docs/
```

`AGENTS.md` 與 `handoff.md` 範本放在 `project-init/references/`，因此安裝單一 Skill 後仍可使用，不依賴原始 Clone 的 Repository 根目錄。

## 安裝

### Windows PowerShell

```powershell
.\scripts\install.ps1
.\scripts\check.ps1
```

### WSL / Ubuntu / macOS

```bash
bash ./scripts/install.sh
bash ./scripts/check.sh
```

預設安裝到（命令目錄依 OpenCode 版本決定）：

```text
~/.config/opencode/skills/
~/.config/opencode/commands/   # v2.x.x；v1.x.x 為 ~/.config/opencode/command/
```

Windows 對應：

```text
C:\Users\<user>\.config\opencode\skills\
C:\Users\<user>\.config\opencode\commands\   # v2.x.x；v1.x.x 為 \.config\opencode\command\
```

安裝腳本會偵測環境中的 OpenCode 版本：在 v1.x.x 複製八個 Core Skills 與兩個 Core Commands；在 v2.x.x 跳過 `workspace-layout` 與 `instructions`（這兩個是 v1-only，v2 由內建 `AGENTS.md` 機制取代），因此只安裝七個 Skills 與一個 Command。腳本不會自動修改既有 `opencode.jsonc`，也不會安裝 Extension Packs 或第三方 plugin。檢查腳本會依版本確認對應的 Skills、Commands 與兩個 Project Init Reference 存在。

## 版本相容性（OpenCode v1 vs v2）

`workspace-layout` Skill 與 `/instructions` Command 設計上僅供 OpenCode **v1.x.x**：

- v1 的 `instructions` 設定欄位會實際載入檔案，`CLAUDE.md` 也是 `AGENTS.md` 的備用來源。
- v2 的 `instructions` 欄位目前不會解析、也不把 `CLAUDE.md` 當備用；專案規則改用內建的 `AGENTS.md` 機制。

因此在 v2 環境：

- `install.sh` / `install.ps1` 偵測到 major ≥ 2 時，自動跳過這兩個元件。
- `check.sh` / `check.ps1` 不再要求它們存在。
- `/teamwork-update-check` 不會提示安裝或升級這兩個元件。

Commands 的安裝／驗證目錄亦依版本決定：v2 使用 v2 推薦的複數 `commands/`，v1（或無法偵測時）維持舊式單數 `command/`，因此 `install.sh` / `install.ps1` 與 `check.sh` / `check.ps1` 都會先偵測 major 版本再決定路徑。`FORCE=1`（PowerShell 用 `-Force`）仍可在 v2 也安裝，並可傳入第二個參數強制指定命令目錄。

若要強制在 v2 也安裝（例如仍想保留 Git 邊界文件），用 `FORCE=1`（PowerShell 用 `-Force`）。這兩個元件在 manifest 中以 `optionalOnV2: true` 標記，偵測方式與安裝／檢查腳本一致：優先 `opencode --version`，退回查桌面版 CLI 路徑。

## OpenCode 專案規則

新專案透過 `project-init` 建立 `AGENTS.md` 與 `handoff.md`（專為全新/空資料夾；已有程式碼與 `AGENTS.md` 的既有專案請改用 v2 內建的 `/init`）。這些檔案應只放 OpenCode 每次工作都需要知道的內容：

- 專案目的與邊界
- 小幅且可審查的修改原則
- 實際 Build、Lint、Test 指令
- SWQA 所需的測試、Log、Verdict、Timeout/Retry 與硬體限制
- 危險或不可回復操作的確認規則
- 完成前必須保存的命令、exit code、測試結果與 Artifact 證據

`handoff.md` 用於保存目前 Session 狀態與驗證證據。對 Python、UART/TTY 或封包測試，應在適用時記錄 DUT/firmware、Console Log、PCAP 與正式報告路徑；摘要不能取代原始證據。

`config-check` 也會檢查全域與專案的 Commands，提示同名覆蓋、無效 frontmatter 或不存在的 Agent，但不會自行刪除或覆寫設定。

`teamwork-update-check` 只在使用者明確要求時讀取團隊兩個 repository，並在任何套用動作前顯示差異與取得確認。

需求釐清、測試失敗分析與精簡程式碼審查等按需能力放在 `opencode-extension-packs`，不增加 Core 的常駐負擔。

## 使用情境

- 個人：Essential Core + 個人選擇的 Extension Packs + GitHub 或本地 Git
- SWQA 團隊：Essential Core + SWQA Automation + Forgejo Integration
- 特定專案：再依需求加入 API、Browser、VoIP 或 Document Pack

## Extension Packs

額外能力放在另一個 Repository：

```text
sawaichi9527/opencode-extension-packs
```

Extension Packs 使用 manifest 分成 Default、Recommended 與 Optional。Core 不會自動安裝其中的第三方 plugin；使用者可透過 `/teamwork-update-check` 取得版本與差異資訊，再自行選擇套用。

## 授權與來源

本專案依 MIT License 發布。上游來源與轉化說明請參閱 [UPSTREAM.md](UPSTREAM.md)。
