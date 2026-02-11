# InfStones AI Agent Workspace Template

> 版本: 1.0 | 更新: 2026-02-11

## 目录结构

```
clawd/
├── AGENTS.md           # [🔒 LOCKED] 工作区行为准则
├── SOUL.md             # [🔒+✏️] 框架统一，允许扩展
├── IDENTITY.md         # [✏️ CUSTOM] agent 身份信息
├── USER.md             # [✏️ CUSTOM] 用户/团队信息
├── TOOLS.md            # [✏️ CUSTOM] 本地工具配置
├── HEARTBEAT.md        # [✏️ CUSTOM] 心跳任务
├── BOOTSTRAP.md        # [🔒 LOCKED] 首次启动引导
├── MEMORY.md           # [✏️ CUSTOM] 长期记忆（自动创建）
├── memory/             # 日志目录
│   └── YYYY-MM-DD.md   # 每日记录
├── skills/             # team 专属 skills
│   └── <skill-name>/
│       ├── SKILL.md
│       └── ...
├── scripts/            # team 专属脚本
│   └── ...
└── canvas/             # UI 画布
    └── index.html
```

## 文件分层规则

### 🔒 LOCKED - 完全统一（不可修改）

这些文件定义公司级规范，所有 agent 必须遵守：

| 文件 | 用途 |
|------|------|
| `AGENTS.md` | 工作区核心行为准则：内存管理、安全规则、Git push 规则、外部/内部操作边界、心跳机制 |
| `BOOTSTRAP.md` | 首次启动流程：引导对话、身份配置步骤 |

### 🔒+✏️ HYBRID - 框架统一 + 允许扩展

| 文件 | 用途 |
|------|------|
| `SOUL.md` | 分为两部分：**Company-Wide Principles**（不可改）和 **Team Customization**（team 自定义） |

### ✏️ CUSTOM - 完全由 Team 自定义

| 文件 | 用途 |
|------|------|
| `IDENTITY.md` | agent 名字、emoji、头像、creature 类型 |
| `USER.md` | 服务对象信息（可以是个人或团队） |
| `TOOLS.md` | 本地工具配置、API credentials 备注、设备信息 |
| `HEARTBEAT.md` | 定期检查任务 |
| `MEMORY.md` | 长期记忆（agent 自动创建和维护） |
| `skills/` | team 专属技能 |
| `scripts/` | team 专属脚本 |

## Team 列表

| Team ID | 全名 | 说明 |
|---------|------|------|
| `dev-dos` | DevOps | 运维团队 |
| `dev-plt` | Platform | 平台团队 |
| `dev-app` | Application | 应用团队 |
| `dev-bkc` | Blockchain | 区块链团队 |
| `dev-fte` | Frontend | 前端团队 |
| `pro-pog` | Product Operation | 产品运营（含客服 Agent） |
| `bus-bog` | Business Operation | 商务运营 |
| `mkt-mkt` | Marketing | 市场营销 |

## 使用指南

### 1. 部署新 Agent

```bash
# Clone 模板
git clone https://github.com/chunyang-infstones/OpenClaw.git my-agent

# 进入工作区
cd my-agent/clawd

# 自定义以下文件：
# - IDENTITY.md (必填)
# - USER.md (必填)
# - SOUL.md 的 Team Customization 部分 (按需)
# - TOOLS.md (按需)
# - HEARTBEAT.md (按需)
```

### 2. 添加 Team Skill

```bash
mkdir -p skills/my-skill
touch skills/my-skill/SKILL.md
# 按照 Skill 模板填写
```

### 3. 首次启动

1. Agent 读取 `BOOTSTRAP.md`
2. 完成身份配置对话
3. 更新 `IDENTITY.md` 和 `USER.md`
4. 删除 `BOOTSTRAP.md`（不需要再用）

## 注意事项

### 安全

- `MEMORY.md` 包含敏感上下文，**禁止在共享 session 中加载**
- API credentials 放在 `.secrets.json`（已 gitignore）
- Slack/Discord escalation 脚本不要暴露 token

### Git

- 所有文件修改后必须 commit + push
- 不要提交 `.clawdbot/` 目录
- 不要提交 `.secrets.json`

### 升级

当模板有更新时：
1. 只更新 🔒 LOCKED 文件
2. ✏️ CUSTOM 文件保持不变
3. SOUL.md 的 Company-Wide Principles 部分需要手动 merge
