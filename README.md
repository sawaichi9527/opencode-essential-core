# OpenCode Essential Core

OpenCode 的跨平台必要核心，目標是讓小型開發團隊在 Windows、WSL、Ubuntu 與 macOS 上，
對環境檢查、專案初始化、工作階段交接與 Git 基本操作採用一致做法。

本專案以 SWQA 自動化開發作為主要驗證場景，但核心內容不綁定公司、部門或特定測試框架，
也可供 SWRD 與個人專案使用。

> 狀態：v0.1.1 小型團隊基準。內容源自
> `mathruffian-dot/opencode-lazy-packs` 的概念，並參考成熟的 AI Coding 精簡修改與驗證原則，
> 但只保留適合 OpenCode 小型團隊使用的部分。

## OpenCode 使用邊界

本 Repository 專門服務 OpenCode 開發流程，主要使用 OpenCode 原生機制：

```text
AGENTS.md                    專案共用規則
.opencode/skills/            專案限定 Skills
~/.config/opencode/skills/   全域共用 Skills
.opencode/commands/          專案限定 Commands
~/.config/opencode/commands/ 全域共用 Commands
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

## 目前包含的 Skills

| Skill | 中文用途 |
|---|---|
| `environment-check` | 檢查 OpenCode、Git、Node.js、Python/uv 與執行平台 |
| `config-check` | 檢查全域與專案域 OpenCode 設定、Skills、Commands 與路徑覆蓋 |
| `project-init` | 使用隨 Skill 安裝的 Reference 建立最小 OpenCode 專案結構 |
| `session-start` | 開始工作前讀取規則、交接與 Git 狀態 |
| `session-close` | 整理本次工作、最新驗證證據、交接與 Git 變更 |
| `git-basic` | 統一安全且可理解的本地 Git 操作 |

## Repository 結構

```text
opencode-essential-core/
├── skills/
│   └── project-init/
│       └── references/
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

預設安裝到：

```text
~/.config/opencode/skills/
```

Windows 對應：

```text
C:\Users\<user>\.config\opencode\skills\
```

安裝腳本複製此 Repository 的完整 Skill 目錄，包含 `project-init/references/`，但不會自動修改既有 `opencode.jsonc` 或安裝 Extension Commands。檢查腳本會確認六個 Core Skills 與兩個 Project Init Reference 是否存在。

## OpenCode 專案規則

新專案透過 `project-init` 建立 `AGENTS.md` 與 `handoff.md`。這些檔案應只放 OpenCode 每次工作都需要知道的內容：

- 專案目的與邊界
- 小幅且可審查的修改原則
- 實際 Build、Lint、Test 指令
- SWQA 所需的測試、Log、Verdict、Timeout／Retry 與硬體限制
- 危險或不可回復操作的確認規則
- 完成前必須保存的命令、exit code、測試結果與 Artifact 證據

`handoff.md` 用於保存目前 Session 狀態與驗證證據。對 Python、UART／TTY 或封包測試，應在適用時記錄 DUT／firmware、Console Log、PCAP 與正式報告路徑；摘要不能取代原始證據。

`config-check` 也會檢查全域與專案的 Commands，提示同名覆蓋、無效 frontmatter 或不存在的 Agent，但不會自行刪除或覆寫設定。

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

## 授權與來源

本專案依 MIT License 發布。上游來源與轉化說明請參閱 [UPSTREAM.md](UPSTREAM.md)。
