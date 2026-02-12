# OpenClaw Agent Template

> 🚀 InfStones standard workspace template for OpenClaw AI agents

This repository provides a standardized workspace structure for all InfStones AI agents. It ensures consistency across teams while allowing flexible customization.

## Quick Start

1. **Clone this template** for your new agent
2. **Fill in** `clawd/AGENT-CONFIG.md` with your team's configuration
3. **Start agent** — it will read AGENT-CONFIG.md, update all files, and introduce itself
4. **Done!** — BOOTSTRAP.md and AGENT-CONFIG.md are deleted automatically

## File Structure

```
clawd/
├── AGENTS.md              # 🔒 LOCKED - Workspace behavior rules
├── SOUL.md                # 🔒+✏️ LOCKED + CUSTOM - Core values + team personality
├── BOOTSTRAP.md           # 📝 TEMPLATE - First-run guide (delete after use)
├── AGENT-CONFIG.md        # 📝 TEMPLATE - Team configuration (delete after use)
├── IDENTITY.md            # ✏️ CUSTOM - Agent identity (created by AGENT-CONFIG)
├── USER.md                # ✏️ CUSTOM - Who this agent serves
├── TOOLS.md               # ✏️ CUSTOM - Tool configuration notes
├── HEARTBEAT.md           # ✏️ CUSTOM - Periodic tasks
├── MEMORY.md              # ✏️ CUSTOM - Long-term memory
├── memory/                # Daily logs (YYYY-MM-DD.md)
├── skills/                # Team-specific skills (branch-managed)
│   ├── master/            # Approved skills
│   └── YYYY-MM-DD/        # Daily changes (reviewed at 9 AM)
├── knowledge/             # Product/project knowledge (branch-managed)
│   ├── master/            # Approved knowledge
│   └── YYYY-MM-DD/        # Daily changes (reviewed at 9 AM)
└── canvas/                # Canvas assets (HTML/CSS/JS)
```

## File Tags

| Tag | Meaning | Example |
|-----|---------|---------|
| 🔒 LOCKED | Company-wide standard, do not modify | AGENTS.md, BOOTSTRAP.md |
| 🔒+✏️ LOCKED + CUSTOM | Fixed framework + team extension | SOUL.md |
| ✏️ CUSTOM | Fully team-customizable | IDENTITY.md, USER.md, TOOLS.md, HEARTBEAT.md |
| 📝 TEMPLATE | One-time configuration (delete after use) | AGENT-CONFIG.md |

## Team IDs

| Team ID | Full Name | Purpose |
|---------|-----------|---------|
| dev-dos | DevOps | Infrastructure & operations |
| dev-plt | Platform | Core platform development |
| dev-app | Application | Application layer |
| dev-bkc | Blockchain | Blockchain integration |
| dev-fte | Frontend | UI/UX development |
| pro-pog | Product Operation | Product & customer support |
| bus-bog | Business Operation | Business operations |
| mkt-mkt | Marketing | Marketing & content |

## Branch Management

**Skills and Knowledge use a master + daily branch workflow:**

1. **Daily work** → Create/modify in `skills/YYYY-MM-DD/` or `knowledge/YYYY-MM-DD/`
2. **Daily review** → At 9 AM, agent summarizes diff and sends to team channel
3. **Team Lead reviews:**
   - ✅ Approved → Merge to `master/`, push to GitHub
   - ❌ Denied → Delete
   - ⏸️ Pending → Carry to next day
4. **New branch** → `master/` + pending changes = new `YYYY-MM-DD/` branch
5. **Cleanup** → Delete old date branch

This ensures knowledge quality while allowing daily iteration.

## Setup Instructions

See [SETUP.md](./SETUP.md) for detailed deployment steps.

## Contributing

For questions or improvements to this template, contact:
- Rudy Lu (@UR256PFEE on Slack)
- Ruby (@U0AC1EHGYTW on Slack)

---

**License:** Internal use only - InfStones AI Agent Program
