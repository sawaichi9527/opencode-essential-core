# OpenCode Essential Core

OpenCode **v2.x.x** 專用的跨平台必要核心套件：以 8 個 Skills 與 6 個 Commands，讓小型開發團隊在 Windows、WSL、Ubuntu 與 macOS 上，對環境檢查、設定檢查、專案初始化、工作階段交接、Git 基本操作、多 repo workspace 邊界與團隊基準更新採用一致做法。

全部能力只依賴 OpenCode 原生機制（`AGENTS.md`、Skills、Commands、`opencode.jsonc`）：安裝時不寫入設定、不安裝第三方 plugin，可與 `opencode-extension-packs` 自由組合。

本專案以 SWQA 自動化開發作為主要驗證場景，但核心內容不綁定公司、部門或特定測試框架，
也可供 SWRD 與個人專案使用。

> 狀態：v2.0.14（基於 OpenCode v2.0.14 驗證），**僅支援 OpenCode v2.x.x**；v1 相容（版本偵測、`instructions` 欄位、單數 `command/` 目錄）已於 2.0.12 移除，詳見 [CHANGELOG](CHANGELOG.md)。
> 內容源自 `mathruffian-dot/opencode-lazy-packs` 的概念，並參考成熟的 AI Coding 精簡修改與驗證原則，
> 只保留適合 OpenCode 小型團隊使用的部分。

## OpenCode 使用邊界

本 Repository 專門服務 OpenCode 開發流程，主要使用 OpenCode 原生機制：

```text
AGENTS.md                     專案共用規則
.opencode/skills/             專案限定 Skills（原生）
.agents/skills/               專案限定 Skills（相容）
~/.config/opencode/skills/    全域共用 Skills（原生）
~/.agents/skills/             全域共用 Skills（相容）
.opencode/commands/           專案限定 Commands
~/.config/opencode/commands/  全域共用 Commands
opencode.jsonc                OpenCode 設定與權限
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
| `environment-check` | 跨平台檢查 OpenCode、Git、Node.js、Python/uv 與執行平台，含 provider／憑證是否就緒 |
| `config-check` | 檢查全域與專案域 OpenCode 設定、Skills、Commands 與路徑覆蓋，含 MCP／Agent 健康檢查 |
| `project-init` | 為全新/空資料夾建立基本專案骨架（`AGENTS.md`、`handoff.md`、`README`、`src/tests/docs`）；既有專案請改用 v2 內建 `/init` |
| `session-start` | 開始工作前確認規則已載入、交接與 Git 狀態 |
| `session-close` | 整理本次工作、最新驗證證據、交接與 Git 變更 |
| `git-basic` | 統一安全且可理解的本地 Git 操作；寫入／禁止項目在 v2 由 runtime permission 強制 |
| `workspace-layout` | 多 repo workspace 的層級判斷與 repo 邊界（讀可跨、寫單一 repo），含 workspace 層規則的載入方式 |
| `teamwork-update-check` | 手動比對團隊 Core 與 Extension Packs repository 的版本與變更，套用前詢問使用者 |

## Commands

Core 提供 6 個手動 command；前 5 個是薄包裝，讓原本只有 Skill 形式的流程也能由使用者直接叫用（載入同名 Skill 並依其規則執行）：

```text
/project-init           全新或空資料夾的專案骨架（既有專案請用內建 /init）
/environment-check      跨平台環境檢查（OpenCode、Git、Node.js、Python/uv、Shell、provider／憑證）
/config-check           全域與專案設定、Skills、Commands、路徑與 MCP／Agent 健康檢查
/session-start          開始工作階段：載入規則、交接與 Git 狀態（預設唯讀）
/session-close          結束工作階段：整理成果、驗證證據、交接與 Git 變更
/teamwork-update-check  比對團隊 Core 與 Extension Packs 版本
```

`/project-init` 只適用全新或空資料夾；既有專案請改用 OpenCode 內建的 `/init`（依實際程式碼推導規則），避免混淆。

既有安裝可透過 `/teamwork-update-check` 取得這 5 個新 command：它們在 Core manifest 中列為新元件，會被標示為 `ADDED` 並在確認後安裝。

`/teamwork-update-check` 會讀取 `sawaichi9527/opencode-essential-core` 與 `sawaichi9527/opencode-extension-packs` 發布的
`manifest/skills.json` 與 `manifest/packs.json`（含外部 plugin 固定版本），比對本機安裝基準
（`~/.config/opencode/teamwork-install-state.json`），找出 skill / plugin 版本更新、
新增與移除的元件、CHANGELOG 與相容性要求，通知差異並在確認後才升級。
它不會由 `session-start` 自動觸發，也不會在未獲得確認前修改本機設定或安裝套件。

Extension Packs 的選用能力（如 `local-llm-dispatch-policy`、SWQA、Browser、Forgejo／GitHub 整合等）由 Extension Packs 自行維護清單與版本；Core 只透過 `/teamwork-update-check` 讀取並比對，不依賴任何特定 provider、GPU 或 Extension Pack。原 `hybrid-workflow` 已於 Extension Packs 2.0.12 移除。

## Repository 結構

```text
opencode-essential-core/
├── commands/
│   ├── project-init.md
│   ├── environment-check.md
│   ├── config-check.md
│   ├── session-start.md
│   ├── session-close.md
│   └── teamwork-update-check.md
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

預設安裝到（原生目錄）：

```text
~/.config/opencode/skills/
~/.config/opencode/commands/
```

OpenCode v2 也會自動搜尋相容目錄 `~/.agents/skills/`（全域）與 `.agents/skills/`（專案）；若改用 `npx skills add -g -a opencode` 安裝第三方 Skill，實際落點會是 `~/.agents/skills/`。同名 Skill 以後註冊者為準，請避免兩處同名。

Windows 對應：

```text
C:\Users\<user>\.config\opencode\skills\
C:\Users\<user>\.config\opencode\commands\
```

安裝腳本會複製全部八個 Core Skills 與一個 Core Command，不做版本偵測。腳本不會自動修改既有 `opencode.jsonc`，也不會安裝 Extension Packs 或第三方 plugin。檢查腳本會確認對應的 Skills、Commands 與兩個 Project Init Reference 存在。

## 版本要求

本套件僅支援 OpenCode **v2.x.x**：

- 版本編號記錄「該版 pack 基於哪個 OpenCode 版本驗證通過」（如 `2.0.12` = 基於 OpenCode v2.0.12 驗證）。OpenCode 單純發版不會觸發 pack 升版；下次對本 pack 檢討或修正時，再以當時的 OpenCode 版本號作為新版號。

- v2 的專案規則使用內建 `AGENTS.md` 機制；v1 獨有的 `instructions` 設定欄位與單數 `command/` 目錄不在支援範圍。
- `/teamwork-update-check` 若偵測到 OpenCode major < 2 或無法確認，會標示 `COMPATIBILITY` 提醒，但唯讀檢查仍會執行。
- `FORCE=1`（PowerShell 用 `-Force`）可用於覆寫既安裝檔案；第二個參數（`-CommandTargetDir`）可強制指定命令目錄。

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
