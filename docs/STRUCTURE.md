# 結構與邊界

## Core 應包含

- OpenCode 環境與設定檢查
- Project Init
- Session Start / Close
- Git 基本安全習慣
- 通用範本
- 跨平台安裝與驗證

## Core 不應包含

- 特定公司 URL、Token、CA 或 Proxy
- 特定 Git Hosting 綁定
- 特定雲端服務
- 特定測試領域框架
- 大型企業稽核或中央 IT 流程

## 全域與專案域

```text
~/.config/opencode/
├── opencode.jsonc
└── skills/                  # 共用 Skill

<project>/
├── AGENTS.md
├── handoff.md
└── .opencode/
    └── skills/              # 專案限定 Skill
```

原則：

- 多數專案都需要的行為，可安裝到全域。
- 與產品、測試框架或專案資料有關的 Skill，優先放在專案域並納入 Git。
