# InfStones AI Agent Workspace Template

This repository contains the standard workspace template for InfStones AI Agents.

## Quick Start

```bash
# Clone this template
git clone https://github.com/chunyang-infstones/OpenClaw.git my-agent

# Enter workspace
cd my-agent/clawd

# Customize your agent (see below)
```

## Directory Structure

```
clawd/
├── AGENTS.md           # 🔒 Workspace behavior rules
├── SOUL.md             # 🔒+✏️ Company principles + team customization
├── IDENTITY.md         # ✏️ Agent identity
├── USER.md             # ✏️ User/team info
├── TOOLS.md            # ✏️ Local tool config
├── HEARTBEAT.md        # ✏️ Periodic tasks
├── BOOTSTRAP.md        # 🔒 First-run guide
├── TEMPLATE-STRUCTURE.md  # Structure documentation
├── memory/             # Daily logs
├── skills/             # Team-specific skills
├── scripts/            # Team-specific scripts
└── canvas/             # UI canvas
```

**Legend:**
- 🔒 LOCKED — Company standard, do not modify
- ✏️ CUSTOM — Team customizable
- 🔒+✏️ HYBRID — Has locked section + customizable section

## Customization Guide

### Required (Before First Run)

1. **IDENTITY.md** — Set agent name, team, emoji
2. **USER.md** — Define who/what team you're serving

### Recommended

3. **SOUL.md** — Edit the "Team Customization" section for role, personality, rules
4. **TOOLS.md** — Add local configs (channel IDs, API notes)
5. **HEARTBEAT.md** — Define periodic check tasks

### Optional

6. **skills/** — Add team-specific skills
7. **scripts/** — Add helper scripts

## Teams

| ID | Name | Description |
|----|------|-------------|
| dev-dos | DevOps | Operations |
| dev-plt | Platform | Platform team |
| dev-app | Application | Application team |
| dev-bkc | Blockchain | Blockchain team |
| dev-fte | Frontend | Frontend team |
| pro-pog | Product Operation | Product ops (incl. support) |
| bus-bog | Business Operation | Business ops |
| mkt-mkt | Marketing | Marketing |

## First Run

1. Agent reads `BOOTSTRAP.md`
2. Complete identity setup conversation
3. Update `IDENTITY.md`, `USER.md`, `SOUL.md`
4. Delete `BOOTSTRAP.md`

## Documentation

See `clawd/TEMPLATE-STRUCTURE.md` for detailed structure documentation.

## Security Notes

- `.secrets.json` — Store credentials here (gitignored)
- `.clawdbot/` — Runtime data (gitignored)
- `MEMORY.md` — Contains sensitive context, never load in shared sessions
