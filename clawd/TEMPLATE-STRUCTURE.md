# InfStones AI Agent Workspace Template

> 版本: 1.1 | 更新: 2026-02-11

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

---

## 文件详解

### AGENTS.md 🔒
**用途:** 工作区核心行为准则，定义 agent 如何与工作区交互

**何时读取:**
- ✅ **每次 session 启动时** — OpenClaw 自动注入到 system prompt
- ✅ 作为 agent 的"行为宪法"持续生效

**内容包括:**
- 内存管理规则（何时读写 memory 文件）
- 安全规则（私密数据保护、破坏性命令限制）
- Git push 规则（改完必须 push）
- 外部 vs 内部操作边界（什么可以自主做，什么要问）
- 群聊行为规范（何时发言、何时沉默）
- 心跳机制（如何利用 heartbeat 做主动检查）
- 渠道回复规则（Slack/Discord 格式、threading）

---

### SOUL.md 🔒+✏️
**用途:** Agent 的人格和价值观

**何时读取:**
- ✅ **每次 session 启动时** — OpenClaw 自动注入到 system prompt
- ✅ Agent 需要判断"我应该怎么做"时参考

**结构:**
```markdown
## Company-Wide Principles (DO NOT MODIFY)  ← 🔒 公司级统一
- 核心价值观
- 沟通风格
- 边界和限制

## Team Customization (EDIT BELOW)  ← ✏️ Team 自定义
- 角色定义
- 性格和语气
- 特殊规则
- 决策权限
```

---

### IDENTITY.md ✏️
**用途:** Agent 的身份信息

**何时读取:**
- ✅ **每次 session 启动时** — OpenClaw 自动注入到 system prompt
- ✅ Agent 自我介绍时
- ✅ 需要显示 avatar/emoji 时

**内容包括:**
- Name — agent 名字
- Team — 所属团队 (dev-dos, pro-pog, etc.)
- Creature — 自我定位 (AI assistant, robot, etc.)
- Vibe — 性格基调 (warm, sharp, calm, etc.)
- Emoji — 签名表情
- Avatar — 头像路径/URL

---

### USER.md ✏️
**用途:** Agent 服务对象的信息

**何时读取:**
- ✅ **每次 session 启动时** — OpenClaw 自动注入到 system prompt
- ✅ Agent 需要了解用户背景时

**内容包括:**
- 用户/团队名称
- 时区
- 联系方式
- 工作风格偏好
- 当前优先级/项目

---

### TOOLS.md ✏️
**用途:** 本地工具和环境配置备忘

**何时读取:**
- ✅ **每次 session 启动时** — OpenClaw 自动注入到 system prompt
- ✅ Agent 需要调用特定工具/API 时查阅

**内容包括:**
- Slack/Discord channel IDs
- API endpoints 和 credentials 备注（实际密钥放 .secrets.json）
- SSH 主机别名
- 设备昵称
- 任何环境特定的配置

---

### HEARTBEAT.md ✏️
**用途:** 定义 heartbeat 时要执行的周期性任务

**何时读取:**
- ✅ **收到 heartbeat poll 时** — Agent 读取并执行列出的任务
- ❌ 普通对话时不读取

**内容包括:**
- 定期检查清单（邮件、日历、mentions）
- 监控任务（Slack channel、Discord tickets）
- 主动汇报任务

**注意:** 文件为空或只有注释 → Agent 回复 `HEARTBEAT_OK`，不执行任何操作

---

### BOOTSTRAP.md 🔒
**用途:** 首次启动引导脚本

**何时读取:**
- ✅ **仅在首次启动时** — 文件存在时 agent 读取并执行引导流程
- ❌ 完成引导后删除，后续不再使用

**引导流程:**
1. 与用户对话确定 agent 身份
2. 更新 IDENTITY.md、USER.md、SOUL.md
3. 可选：配置消息渠道（Slack/Discord/WhatsApp）
4. 删除 BOOTSTRAP.md

---

### MEMORY.md ✏️
**用途:** Agent 的长期记忆（精炼版）

**何时读取:**
- ✅ **仅在 main session（与用户直接对话）时** — 自动加载
- ❌ **共享 session（Discord/群聊）时禁止加载** — 防止敏感信息泄露

**内容包括:**
- 重要决策和原因
- 用户偏好和习惯
- 项目背景和进展
- 经验教训

**维护:** Agent 定期从 `memory/YYYY-MM-DD.md` 提炼重要内容到此文件

---

### memory/ 目录 ✏️
**用途:** 每日原始记录

**何时读取:**
- ✅ **每次 session 启动时** — Agent 读取 today + yesterday 的文件
- ✅ **memory flush 时** — Agent 写入当天记录

**文件命名:** `YYYY-MM-DD.md`（如 `2026-02-11.md`）

**内容:** 当天发生的事件、对话摘要、任务进展、临时备忘

---

### skills/ 目录 ✏️
**用途:** Team 专属技能定义

**何时读取:**
- ✅ **任务匹配 skill description 时** — Agent 读取对应 SKILL.md
- ❌ 普通对话时不主动读取

**结构:**
```
skills/
└── discord-mod/
    ├── SKILL.md        # 技能定义和操作指南
    ├── knowledge/      # 知识库（可选）
    └── scripts/        # 辅助脚本（可选）
```

**SKILL.md 包括:**
- 角色定义
- 操作规则
- 工作流程
- 输出格式

---

### scripts/ 目录 ✏️
**用途:** Team 专属辅助脚本

**何时读取:**
- ✅ **需要执行特定操作时** — Agent 通过 exec 调用
- 常见用途：Slack/Discord 消息发送、API 调用封装

**示例:**
- `slack-escalate.sh` — 发送消息到 Slack channel
- `discord-escalate.sh` — 发送消息到 Discord channel

---

### canvas/ 目录
**用途:** UI 画布（Web UI 展示用）

**何时读取:**
- ✅ **需要展示可视化内容时** — 通过 canvas tool 调用

---

## 文件分层规则

### 🔒 LOCKED - 完全统一（不可修改）

| 文件 | 用途 |
|------|------|
| `AGENTS.md` | 工作区核心行为准则 |
| `BOOTSTRAP.md` | 首次启动流程 |

### 🔒+✏️ HYBRID - 框架统一 + 允许扩展

| 文件 | 用途 |
|------|------|
| `SOUL.md` | Company-Wide Principles（🔒）+ Team Customization（✏️） |

### ✏️ CUSTOM - 完全由 Team 自定义

| 文件 | 用途 |
|------|------|
| `IDENTITY.md` | agent 身份信息 |
| `USER.md` | 服务对象信息 |
| `TOOLS.md` | 本地工具配置 |
| `HEARTBEAT.md` | 定期检查任务 |
| `MEMORY.md` | 长期记忆 |
| `memory/` | 每日记录 |
| `skills/` | team 专属技能 |
| `scripts/` | team 专属脚本 |

---


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

---

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
