---
name: daily-standup
description: Daily 9 AM (Asia/Shanghai) review and processing of skills/knowledge date branches. Merge approved changes to master, delete denied branches, and carry over pending items to new date. Use when triggered by cron job for daily standup review.
---

# Daily Standup

Daily 9 AM (Asia/Shanghai) review and processing of skills/knowledge date branches.

## Trigger

Cron job triggers daily at 9:00 AM (Asia/Shanghai).

## Workflow

### 1. Identify Date Branches

Scan `skills/` and `knowledge/` directories for date branch folders (format: `YYYY-MM-DD`).

**Priority**: Process oldest date branches first (sorted by date, earliest first).

### 2. For Each Date Branch

#### Step 1: Generate Diff Report

Compare date branch with master branch:

```bash
# skills diff
diff -r skills/master skills/2026-02-12

# knowledge diff
diff -r knowledge/master knowledge/2026-02-12
```

**Diff report format** (send to Slack as Markdown):

```
## Daily Standup Review - 2026-02-12

### Skills Diff:
<diff content>

### Knowledge Diff:
<diff content>

### Decision Options:
- Approve: Merge to master, delete date branch
- Deny: Delete date branch
- Pending: Carry over to new date branch
```

Send to specified channel (from Team Channel configuration in AGENT-CONFIG.md or TOOLS.md).

#### Step 2: Wait for Team Lead Decision

**Decision format:**

- `@<agent_name> approve` → Merge to master, delete date branch
- `@<agent_name> deny` → Delete date branch
- `@<agent_name> pending` → Carry over to new date branch

**Timeout**: 1 hour without response → Default to pending.

#### Step 3: Execute Decision

**If Approve:**

```bash
# Copy skills changes to master
cp -r skills/2026-02-12/* skills/master/

# Copy knowledge changes to master
cp -r knowledge/2026-02-12/* knowledge/master/

# Commit to GitHub
cd <workspace_path>
git add skills/master knowledge/master
git commit -m "Merge daily standup changes: 2026-02-12"
git push

# Delete date branch
rm -rf skills/2026-02-12 knowledge/2026-02-12
```

**If Deny:**

```bash
# Delete date branch directly
rm -rf skills/2026-02-12 knowledge/2026-02-12
```

**If Pending:**

1. Create new date branch (if not exists):
   ```bash
   mkdir -p skills/2026-02-13 knowledge/2026-02-13
   ```

2. Copy pending changes to new date branch:
   ```bash
   cp -r skills/2026-02-12/* skills/2026-02-13/
   cp -r knowledge/2026-02-12/* knowledge/2026-02-13/
   ```

3. Delete old date branch:
   ```bash
   rm -rf skills/2026-02-12 knowledge/2026-02-12
   ```

4. **New date branch composition:**
   - Complete master branch content (as base)
   - Pending changes (overlaid on top)

   **Execution:**
   ```bash
   # First copy master to new date branch
   cp -r skills/master/* skills/2026-02-13/
   cp -r knowledge/master/* knowledge/2026-02-13/

   # Then overlay pending changes
   cp -r skills/2026-02-12/* skills/2026-02-13/
   cp -r knowledge/2026-02-12/* knowledge/2026-02-13/
   ```

### 3. Process All Date Branches

Process in date order until all date branches have decisions.

## Error Handling

1. **No date branches**: Send no message, exit immediately.
2. **Git push failure**: Send error report to Team Channel, pause operation.
3. **File conflicts**: Report to Team Channel, wait for manual resolution.

## Logging

After each execution, record in `memory/YYYY-MM-DD.md`:

```markdown
## Daily Standup Review

- **Date**: 2026-02-12
- **Branches processed**: 2026-02-11, 2026-02-12
- **Decisions**:
  - 2026-02-11: Approve
  - 2026-02-12: Pending
- **GitHub commit**: <commit_hash>
```
