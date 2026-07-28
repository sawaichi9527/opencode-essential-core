# OpenCode Essential Core

OpenCode 的跨平台必要核心，目標是讓小型開發團隊在 Windows、WSL、Ubuntu 與 macOS 上，
對環境檢查、專案初始化、工作階段交接與 Git 基本操作採用一致做法。

本專案以 SWQA 自動化開發作為主要驗證場景，但核心內容不綁定公司、部門或特定測試框架，
也可供 SWRD 與個人專案使用。

> 狀態：初始轉化版本（v0.1 planning baseline）。內容源自
> `mathruffian-dot/opencode-lazy-packs` 的概念，已重新拆分與簡化。

## 設計原則

- Core 只保留多數 OpenCode 使用者都需要的能力。
- 不在 Core 內綁定 GitHub、Forgejo、NotebookLM、Supabase 或其他特定服務。
- 不把 Windows、Linux 與 macOS 拆成多套不同 Harness。
- 危險 Git 操作、push 與破壞性檔案操作必須先詢問。
- 不在 Repository 或設定範本中保存 Token、密碼或內部 URL。

## 目前包含的 Skills

| Skill | 中文用途 |
|---|---|
| `environment-check` | 檢查 OpenCode、Git、Node.js、Python/uv 與執行平台 |
| `config-check` | 檢查全域與專案域 OpenCode 設定 |
| `project-init` | 建立最小且通用的專案結構 |
| `session-start` | 開始工作前讀取規則、交接與 Git 狀態 |
| `session-close` | 整理本次工作、更新交接並準備 Git 變更 |
| `git-basic` | 統一安全且可理解的本地 Git 操作 |

## Repository 結構

```text
opencode-essential-core/
├── skills/
├── templates/
├── scripts/
├── examples/
└── docs/
```

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

安裝腳本只複製此 Repository 的 `skills/`，不會自動修改既有 `opencode.jsonc`。

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
