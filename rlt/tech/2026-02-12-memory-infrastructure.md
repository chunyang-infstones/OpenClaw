# Memory Infrastructure for OpenClaw

**日期**: 2026-02-12
**来源**: Twitter @calicastle - "如何给 OpenClaw 搭建一套「永不失忆」的记忆系统"
**Digest**: [docs/twitter/2026-02-12-openclaw-memory-system.md](../../docs/twitter/2026-02-12-openclaw-memory-system.md)

---

## 来源

Cali Castle 分享了他为 OpenClaw 搭建的三层记忆系统，解决了 agent 因 session 过期导致的记忆丢失问题。

核心架构：
1. **Daily Context Sync** (每晚 11 点) - 捕获当天所有对话
2. **Weekly Memory Compound** (周日晚 10 点) - 知识蒸馏
3. **Hourly Micro-Sync** (白天 5 次) - 安全网
4. **Vector Search** (qmd) - 语义检索

---

## 改进点

### 1. 实现三层记忆架构

**当前状态**:
- 我们已有 `MEMORY.md` 和 `memory/YYYY-MM-DD.md` 文件结构
- AGENTS.md 中有记忆读取规则
- 但没有自动化的定时同步机制

**改进方案**:
建立三个 cron jobs 实现自动记忆维护：

#### a) Daily Sync (每晚 23:00)
```json
{
  "name": "Daily Memory Sync",
  "schedule": {
    "kind": "cron",
    "expr": "0 23 * * *",
    "tz": "Asia/Shanghai"
  },
  "payload": {
    "kind": "agentTurn",
    "message": "DAILY MEMORY SYNC — Use sessions_list to get today's sessions, then sessions_history for each. Distill key decisions, action items, and conversations into memory/YYYY-MM-DD.md with structured sections (## Decisions Made, ## Action Items, ## Key Conversations, ## Technical Notes). Then run qmd update && qmd embed to refresh vector search index.",
    "model": "anthropic/claude-sonnet-4-5"
  },
  "sessionTarget": "isolated"
}
```

#### b) Weekly Compound (周日 22:00)
```json
{
  "name": "Weekly Memory Compound",
  "schedule": {
    "kind": "cron",
    "expr": "0 22 * * 0",
    "tz": "Asia/Shanghai"
  },
  "payload": {
    "kind": "agentTurn",
    "message": "WEEKLY MEMORY COMPOUND — Read all memory/YYYY-MM-DD.md files from this week (last 7 days). Update MEMORY.md with: new preferences, decision patterns, project status changes. Prune stale information. Then run qmd update && qmd embed.",
    "model": "anthropic/claude-sonnet-4-5"
  },
  "sessionTarget": "isolated"
}
```

#### c) Hourly Micro-Sync (工作时间)
```json
{
  "name": "Hourly Micro-Sync",
  "schedule": {
    "kind": "cron",
    "expr": "0 10,13,16,19,22 * * *",
    "tz": "Asia/Shanghai"
  },
  "payload": {
    "kind": "agentTurn",
    "message": "MICRO-SYNC — Check sessions_list for meaningful activity in last 3 hours. If yes, append brief summary to today's memory/YYYY-MM-DD.md and run qmd update && qmd embed. If nothing notable, exit silently without notification.",
    "model": "anthropic/claude-sonnet-4-5"
  },
  "sessionTarget": "isolated",
  "delivery": { "mode": "none" }
}
```

**优先级**: 🔴 高
**预期效果**:
- 零记忆丢失
- Agent 每次启动都带完整 context
- 自动识别工作习惯和偏好模式

---

### 2. 优化 AGENTS.md 记忆检索规则

**当前状态**:
AGENTS.md 已经有 "Memory is limited" 的提醒，但没有强制使用 qmd 的规则。

**改进方案**:
在 AGENTS.md 中添加明确的检索规则：

```markdown
## 🔍 Memory Retrieval (MANDATORY)

Never read MEMORY.md or memory/*.md in full for lookups. Always use qmd:

1. **First**: `qmd query "<question>"` — semantic search with reranking
2. **Then**: `qmd get <file>:<line> -l 20` — pull only the needed snippet
3. **Fallback**: Only if qmd returns nothing, fall back to reading files directly

Why: Reading full files wastes tokens and time. Search first, read targeted snippets second.
```

**优先级**: 🟡 中
**预期效果**:
- 减少 token 消耗
- 提升检索速度
- 养成 agent 使用搜索的习惯

---

### 3. 标准化每日日志格式

**当前状态**:
`memory/2026-02-12.md` 存在但格式自由度较高。

**改进方案**:
在 AGENTS.md 中定义标准日志模板：

```markdown
## 📝 Daily Log Template

Use this structure for memory/YYYY-MM-DD.md:

# YYYY-MM-DD Memory

## Decisions Made
- <decision> → <reason/context>

## Action Items
- [ ] <task> (owner: <name>, due: <date>)
- [x] <completed task>

## Key Conversations
- **Topic**: <summary> (participants: <names>)
- **Outcome**: <result/next steps>

## Technical Notes
- <code patterns/bugs/solutions>

## Lessons Learned
- <insights that should inform future decisions>
```

**优先级**: 🟢 低
**预期效果**:
- 更好的可读性
- 更容易被 vector search 索引
- Weekly compound 时更容易提取结构化信息

---

### 4. 设置 qmd 配置和定期重建索引

**当前状态**:
不确定 qmd 是否已配置，是否启用了 vector search backend。

**改进方案**:

a) 检查 qmd 配置状态：
```bash
openclaw status  # 查看 memory backend
qmd status       # 检查 qmd 是否可用
```

b) 如果未启用，参考文档配置 qmd backend：
- 启用 `memory_backend: qmd`
- 配置 embedding model
- 初始化索引：`qmd update && qmd embed`

c) 添加每周深度重建索引的 cron job (可选，防止索引碎片化)：
```json
{
  "name": "Weekly Deep Index Rebuild",
  "schedule": {
    "kind": "cron",
    "expr": "0 2 * * 1",
    "tz": "Asia/Shanghai"
  },
  "payload": {
    "kind": "agentTurn",
    "message": "Deep index rebuild: qmd update --full && qmd embed --reindex",
    "model": "anthropic/claude-sonnet-4-5"
  },
  "sessionTarget": "isolated"
}
```

**优先级**: 🟡 中
**预期效果**:
- 语义搜索可用
- 索引保持新鲜
- 检索准确率提升

---

## 建议行动

### Phase 1: 立即行动 (今天)
1. ✅ 已创建 digest 文件
2. ⬜ 创建三个 cron jobs (daily/weekly/hourly)
3. ⬜ 检查 qmd 配置状态

### Phase 2: 本周内
4. ⬜ 更新 AGENTS.md 添加 Memory Retrieval 强制规则
5. ⬜ 定义标准日志模板
6. ⬜ 如果 qmd 未启用，配置 memory_backend

### Phase 3: 观察期 (两周)
7. ⬜ 监控 cron jobs 执行情况
8. ⬜ 检查 MEMORY.md 的蒸馏质量
9. ⬜ 调整时间表和 prompt (如有必要)

---

## 关联项目/领域

- **OpenClaw Memory System** - 核心改进
- **Automation & Cron Jobs** - 定时任务管理
- **Knowledge Management** - 知识图谱和检索
- **Agent Reliability** - 提升 agent 的持续性和可靠性

---

## 优先级

🔴 **高优先级** - Memory infrastructure 是投资回报率最高的改进

原因：
> Memory infrastructure 比 agent intelligence 重要得多。一个有完善记忆系统的普通模型，比一个失忆的顶级模型有用得多。

立即开始搭建，预计 1-2 天可完成基础架构。

---

## 参考资料

- 原文: https://x.com/calicastle/status/2021229394724102229
- OpenClaw Docs: https://docs.openclaw.ai/concepts/memory
- qmd backend: https://docs.openclaw.ai/concepts/memory#qmd-backend-experimental
- Cron Jobs: https://docs.openclaw.ai/tools/cron
