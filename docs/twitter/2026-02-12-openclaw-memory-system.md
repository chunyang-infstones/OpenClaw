# Digest: 如何给 OpenClaw 搭建一套「永不失忆」的记忆系统

**来源**: @calicastle (Cali Castle)
**时间**: 2026-02-10 14:26:54 UTC
**链接**: https://x.com/calicastle/status/2021229394724102229
**互动**: ❤️ 755 | 🔁 154 | 💬 28

---

## 核心问题

作者用 OpenClaw 跑 main agent + sub-agents 系统，前三天一切正常，但第四天发现 **两天的对话、决策、action items 全部蒸发**。原因：
- Session 过期
- Context window 刷新
- 没有自动化的记忆捕获机制

> 这就像你雇了一个天才员工，但每天早上他走进办公室，都不记得昨天发生了什么。

---

## 解决方案：三层记忆架构

### 文件结构
```
workspace/
├── MEMORY.md          # 主记忆文件，每次 session 自动注入
├── AGENTS.md          # Agent 行为规则
├── memory/
│   ├── 2026-02-07.md  # 每日日志
│   ├── 2026-02-08.md
│   ├── team.md        # 长期参考文件
│   └── projects.md
```

### Layer 1: Daily Context Sync (每日自动捕获)
- **时间**: 每晚 11 点
- **操作**:
  1. 调用 `sessions_list` 拉取当天所有 session
  2. 用 `sessions_history` 读取每个 session 的完整对话
  3. 蒸馏成结构化日志，写入 `memory/YYYY-MM-DD.md`
  4. 跑 `qmd update` 和 `qmd embed` 重新索引向量搜索

```json
{
  "schedule": { "kind": "cron", "expr": "0 23 * * *", "tz": "Asia/Taipei" },
  "payload": {
    "kind": "agentTurn",
    "message": "DAILY MEMORY SYNC — pull sessions_list for today, read sessions_history for each, distill key decisions/action items/conversations into memory/YYYY-MM-DD.md with ## headers and bullet points, then run qmd update && qmd embed",
    "model": "anthropic/claude-sonnet-4-5"
  },
  "sessionTarget": "isolated"
}
```

**每日日志格式**:
```markdown
# 2026-02-09 Daily Log

## Decisions Made
- 决定用 three-layer memory architecture 替代单文件方案
- Linear project ZOLPLAY-142 优先级调整为 urgent

## Action Items
- [ ] 完成 qmd vector search 集成
- [x] 修复 cron timezone 配置 bug

## Key Conversations
- 讨论了 agent memory 的最佳实践
- Review 了新的 landing page 设计稿，反馈已同步到 Figma

## Technical Notes
- qmd embed 需要在每次 memory 写入后执行才能保持索引新鲜
```

### Layer 2: Weekly Memory Compound (每周知识复利)
- **时间**: 每周日晚上 10 点
- **操作**:
  1. 读取本周全部 7 个日志文件
  2. 更新 `MEMORY.md`，提取新的偏好、决策模式、项目状态变化
  3. 剪枝，删除过时的信息
  4. 重新索引 qmd

```json
{
  "schedule": { "kind": "cron", "expr": "0 22 * * 0", "tz": "Asia/Taipei" },
  "payload": {
    "kind": "agentTurn",
    "message": "WEEKLY MEMORY COMPOUND — read all memory/YYYY-MM-DD.md files from this week, update MEMORY.md with new preferences, decision patterns, project status changes, prune stale info, then run qmd update && qmd embed",
    "model": "anthropic/claude-sonnet-4-5"
  },
  "sessionTarget": "isolated"
}
```

> 这种积累是指数级的。每一周的蒸馏都会让 MEMORY.md 变得更精准、更懂你。

### Layer 3: Hourly Micro-Sync (安全网)
- **时间**: 白天 10 点、1 点、4 点、7 点、10 点
- **操作**:
  - 检查最近 3 小时是否有有意义的活动
  - 如果有，追加简要摘要到今天的日志
  - 如果没有，安静退出

```json
{
  "schedule": { "kind": "cron", "expr": "0 10,13,16,19,22 * * *", "tz": "Asia/Taipei" },
  "payload": {
    "kind": "agentTurn",
    "message": "MICRO-SYNC — check if meaningful activity happened in last 3 hours via sessions_list. If yes, append a brief summary note to today's memory/YYYY-MM-DD.md and run qmd update && qmd embed. If nothing notable, do nothing silently.",
    "model": "anthropic/claude-sonnet-4-5"
  },
  "sessionTarget": "isolated"
}
```

### 底层: Vector Search (语义搜索)
- **工具**: qmd (BM25 + vector search + reranking)
- **用法**:
  ```bash
  qmd query "上周关于 landing page 的讨论结论是什么"
  qmd get <file>:<line> -l 20
  ```

**AGENTS.md 规则**:
```markdown
## Memory Retrieval (MANDATORY)
Never read MEMORY.md or memory/*.md in full for lookups. Use qmd:
1. qmd query "<question>" — combined search with reranking
2. qmd get <file>:<line> -l 20 — pull only the snippet you need
3. Only if qmd returns nothing: fall back to reading files
```

---

## 效果

**以前**: 每次新 session，agent 像新来的实习生，什么都要重新解释

**现在**:
- 启动就带 `MEMORY.md` 的完整 context
- 知道我是谁，项目在什么阶段
- 自动用 qmd 搜索，几秒找到三天前的对话结论
- Weekly compound 准确总结出作者的工作习惯和代码 review 偏好

> 跑了两轮之后，MEMORY.md 里关于我的工作习惯的描述准确得有点吓人。

---

## 核心观点

**Memory infrastructure 比 agent intelligence 重要得多。**

一个有完善记忆系统的普通模型，比一个失忆的顶级模型有用得多。

> 别急着换最新的模型，先把记忆基础设施搭好。这是投资回报率最高的事情。

---

## 技术栈

- **OpenClaw**: 24/7 运行在 Mac mini
- **qmd memory_backend**: 记忆后端
- **Cron Jobs**: 定时任务调度
- **Isolated Sessions**: 避免污染主 session
- **Claude Sonnet**: 日常蒸馏 (Opus 用于强推理)
