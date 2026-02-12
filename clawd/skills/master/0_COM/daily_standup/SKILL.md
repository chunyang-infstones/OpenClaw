# Daily Standup Skill

**Purpose**: 每天9点审核并处理 skills/knowledge 的日期分支改动，将 approved 的合并到 master，denied 的删除，pending 的带到新日期。

---

## 触发条件

Cron job 每天 9:00 AM (Asia/Shanghai) 自动触发。

---

## 执行流程

### 1. 识别当前日期分支

读取 `skills/` 和 `knowledge/` 目录，找到所有日期分支文件夹（格式：`YYYY-MM-DD`）。

**优先级**：先处理最老的日期分支（按日期排序，最早的先处理）。

### 2. 对每个日期分支，执行以下操作

#### Step 1: 生成 Diff 报告

对比日期分支与 master 分支的差异：

```bash
# skills diff
diff -r skills/master skills/2026-02-12

# knowledge diff
diff -r knowledge/master knowledge/2026-02-12
```

**Diff 报告格式**（以 Markdown 发送到 Slack）：

```
## 📅 Daily Standup Review - 2026-02-12

### Skills Diff:
<diff 内容>

### Knowledge Diff:
<diff 内容>

### 决策选项：
- ✅ Approve: 合并到 master，删除日期分支
- ❌ Deny: 删除日期分支
- ⏸️ Pending: 带到新日期分支
```

发送到指定频道（根据 AGENT-CONFIG.md 中的 Team Channel 配置）。

#### Step 2: 等待 Team Lead 决策

**决策格式**：

- `@<agent_name> approve` → 合并到 master，删除日期分支
- `@<agent_name> deny` → 删除日期分支
- `@<agent_name> pending` → 带到新日期分支

**等待时间**：1小时内未回复 → 默认 pending。

#### Step 3: 执行决策

**如果 Approve**：

```bash
# 复制 skills 改动到 master
cp -r skills/2026-02-12/* skills/master/

# 复制 knowledge 改动到 master
cp -r knowledge/2026-02-12/* knowledge/master/

# 提交到 GitHub
cd <workspace_path>
git add skills/master knowledge/master
git commit -m "Merge daily standup changes: 2026-02-12"
git push

# 删除日期分支
rm -rf skills/2026-02-12 knowledge/2026-02-12
```

**如果 Deny**：

```bash
# 直接删除日期分支
rm -rf skills/2026-02-12 knowledge/2026-02-12
```

**如果 Pending**：

1. 创建新日期分支（如果不存在）：
   ```bash
   mkdir -p skills/2026-02-13 knowledge/2026-02-13
   ```

2. 将 pending 的改动复制到新日期分支：
   ```bash
   cp -r skills/2026-02-12/* skills/2026-02-13/
   cp -r knowledge/2026-02-12/* knowledge/2026-02-13/
   ```

3. 删除老日期分支：
   ```bash
   rm -rf skills/2026-02-12 knowledge/2026-02-12
   ```

4. **新日期分支的组成**：
   - Master 分支的完整内容（作为基础）
   - Pending 的改动（覆盖到上面）

   **执行方式**：
   ```bash
   # 先复制 master 到新日期分支
   cp -r skills/master/* skills/2026-02-13/
   cp -r knowledge/master/* knowledge/2026-02-13/

   # 然后把 pending 的改动覆盖上去
   cp -r skills/2026-02-12/* skills/2026-02-13/
   cp -r knowledge/2026-02-12/* knowledge/2026-02-13/
   ```

### 3. 循环处理所有日期分支

按日期顺序处理，直到所有日期分支都被决策完毕。

---

## 错误处理

1. **没有日期分支**：不发送任何消息，直接结束。
2. **Git push 失败**：发送错误报告到 Team Channel，暂停操作。
3. **文件冲突**：报告到 Team Channel，等待手动处理。

---

## 输出日志

每次执行后，在 `memory/YYYY-MM-DD.md` 中记录：

```markdown
## Daily Standup Review

- **日期**: 2026-02-12
- **处理的分支**: 2026-02-11, 2026-02-12
- **决策结果**:
  - 2026-02-11: Approve ✅
  - 2026-02-12: Pending ⏸️
- **GitHub 提交**: <commit_hash>
```
