# Agent Setup Guide

Step-by-step guide to set up a new AI agent using the InfStones workspace template.

---

## Prerequisites

- macOS or Linux machine
- Node.js 18+ installed
- Git installed
- OpenClaw account (or API keys for supported providers)

---

## Step 1: Install OpenClaw

```bash
# Install OpenClaw globally
npm install -g openclaw

# Verify installation
openclaw --version
```

---

## Step 2: Initialize OpenClaw

```bash
# Run the setup wizard
openclaw init

# Follow the prompts:
# - Choose provider (Anthropic, OpenAI, etc.)
# - Enter API keys
# - Set workspace location (default: ~/clawd)
```

This creates:
- `~/.openclaw/openclaw.json` — configuration file
- `~/clawd/` — default workspace directory

---

## Step 3: Clone the Template

```bash
# Navigate to home directory
cd ~

# Backup existing workspace (if any)
mv clawd clawd-backup

# Clone the template
git clone https://github.com/chunyang-infstones/OpenClaw.git clawd-template

# Copy template workspace to clawd
cp -r clawd-template/clawd ~/clawd

# Clean up
rm -rf clawd-template
```

Your workspace now has the standard structure:
```
~/clawd/
├── AGENTS.md            # 🔒 LOCKED - Workspace rules
├── AGENT-CONFIG.md      # 📝 TEMPLATE - First-run config (delete after use)
├── SOUL.md              # 🔒+✏️ LOCKED + CUSTOM - Identity & values
├── IDENTITY.md          # ✏️ CUSTOM - Agent identity
├── USER.md              # ✏️ CUSTOM - User/team profile
├── TOOLS.md             # ✏️ CUSTOM - Tool configurations
├── HEARTBEAT.md         # ✏️ CUSTOM - Periodic tasks
├── MEMORY.md            # ✏️ CUSTOM - Long-term memory
├── memory/              # Daily logs (YYYY-MM-DD.md)
├── skills/              # Team-specific skills (branch-managed)
│   └── master/          # Approved skills
├── knowledge/           # Product knowledge (branch-managed)
│   └── master/          # Approved knowledge
└── canvas/              # Canvas assets
```

---

## Step 4: Initialize Git for Your Workspace

```bash
cd ~/clawd

# Initialize as new repo (removes template history)
rm -rf .git
git init
git add .
git commit -m "Initial workspace setup from template"

# Connect to your team's repo (optional but recommended)
git remote add origin https://github.com/YOUR-ORG/YOUR-AGENT-REPO.git
git push -u origin main
```

---

## Step 5: Configure Your Agent

**Option 1: Use AGENT-CONFIG.md (Recommended)**

Edit `~/clawd/AGENT-CONFIG.md` and fill in all sections, then send the agent:

```
Hello! Please read AGENT-CONFIG.md, configure yourself, and delete it.
```

The agent will:
1. Read AGENT-CONFIG.md
2. Populate IDENTITY.md, USER.md, SOUL.md, TOOLS.md, HEARTBEAT.md
3. Delete AGENT-CONFIG.md

**Option 2: Manual Configuration**

Directly edit these files:

- **IDENTITY.md** — Name, team ID, emoji, avatar
- **USER.md** — Who this agent serves, contact info, preferences
- **SOUL.md** → **Team Customization** section — Role, personality, rules
- **TOOLS.md** — API keys, channel IDs, tool configs
- **HEARTBEAT.md** — Periodic tasks

---

## Step 6: Start OpenClaw

```bash
# Start the gateway
openclaw start

# Or run in foreground for debugging
openclaw gateway
```

---

## Step 7: First Conversation

Choose the method that fits your environment:

### Option A: CLI Chat (Recommended for VPS/Headless)

```bash
# Send first message directly
openclaw chat -m "Hello! Please read BOOTSTRAP.md and complete the onboarding process."

# Or start interactive CLI chat
openclaw
```

### Option B: Via Slack/Discord Channel

If you've already configured channels (Step 8), just:
1. Go to the configured Slack/Discord channel
2. Mention the agent: `@AgentName Hello! Please read BOOTSTRAP.md and complete onboarding.`

### Option C: Web Chat (Local Machine or SSH Tunnel)

For local machines with a browser:
```bash
openclaw chat
# Opens http://localhost:18789
```

For VPS without browser, use SSH port forwarding:
```bash
# On your local machine, create tunnel to VPS
ssh -L 18789:localhost:18789 user@your-vps-ip

# Then open http://localhost:18789 in your local browser
```

### First Message

If using AGENT-CONFIG.md:

```
Hello! Please read AGENT-CONFIG.md, configure yourself, and delete it.
```

The agent will:
1. Read AGENT-CONFIG.md
2. Fill in IDENTITY.md, USER.md, SOUL.md, TOOLS.md, HEARTBEAT.md
3. Delete AGENT-CONFIG.md
4. Introduce itself
5. Start normal operation

If you manually configured files, just say hello:

```
Hello! What's your name?
```

---

## Step 8: Connect Channels (Optional)

### Slack

#### 8.1 Create Slack App

1. Go to https://api.slack.com/apps → **Create New App** → **From scratch**
2. Name it (e.g., "Team Agent") and select your workspace

#### 8.2 Configure Bot Permissions

Go to **OAuth & Permissions** → **Scopes** → **Bot Token Scopes**, add:
- `chat:write`
- `channels:history`
- `groups:history`
- `im:history`
- `reactions:write`
- `users:read`

#### 8.3 Enable Socket Mode

Go to **Socket Mode** → Enable → Create an App-Level Token with `connections:write` scope.
Save the `xapp-...` token.

#### 8.4 Install to Workspace

Go to **Install App** → Install to Workspace → Copy the `xoxb-...` Bot Token.

#### 8.5 Add to OpenClaw Config

Edit the config file directly (no conversation needed):

```bash
nano ~/.openclaw/openclaw.json
```

Add/merge this into your config:

```json
{
  "channels": {
    "slack": {
      "enabled": true,
      "mode": "socket",
      "dm": {
        "policy": "allowlist",
        "allowFrom": ["YOUR_SLACK_USER_ID"]
      },
      "accounts": {
        "default": {
          "botToken": "xoxb-your-bot-token",
          "appToken": "xapp-your-app-token"
        }
      }
    }
  },
  "plugins": {
    "entries": {
      "slack": {
        "enabled": true
      }
    }
  }
}
```

**Find your Slack User ID:** Click your profile in Slack → **...** → **Copy member ID**

#### 8.6 Restart and Test

```bash
openclaw restart

# Check logs
openclaw logs | grep -i slack
```

Then DM the bot in Slack to trigger the first conversation.

### Discord

1. Create a Discord app at https://discord.com/developers/applications
2. Go to **Bot** → Create bot → Copy token
3. Enable **Message Content Intent** under **Privileged Gateway Intents**
4. Add to config:

```json
{
  "channels": {
    "discord": {
      "enabled": true,
      "accounts": {
        "default": {
          "token": "your-discord-bot-token"
        }
      }
    }
  },
  "plugins": {
    "entries": {
      "discord": {
        "enabled": true
      }
    }
  }
}
```

5. Invite bot to server using OAuth2 URL with `bot` scope and required permissions

---

## Step 9: Verify Setup

Check that everything is working:

```bash
# Check gateway status
openclaw status

# View logs
openclaw logs

# Test a simple command
openclaw chat -m "What's your name?"
```

---

## Troubleshooting

### Agent doesn't respond
- Check `openclaw status` for errors
- Verify API keys in `~/.openclaw/openclaw.json`
- Check logs with `openclaw logs`

### Git push fails
- Verify remote is set: `git remote -v`
- Check credentials: `git config --list`

### Channel not connecting
- Verify tokens are correct
- Check channel is enabled in config
- Restart gateway: `openclaw restart`

---

## Quick Reference

| Command | Description |
|---------|-------------|
| `openclaw start` | Start gateway daemon |
| `openclaw stop` | Stop gateway daemon |
| `openclaw restart` | Restart gateway |
| `openclaw status` | Check status |
| `openclaw chat` | Open web chat |
| `openclaw config` | Edit configuration |
| `openclaw logs` | View logs |

---

## Next Steps

1. **Test the agent** — Have a conversation, verify personality matches SOUL.md
2. **Add skills** — Copy relevant skills to `skills/` directory
3. **Set up heartbeat** — Configure periodic tasks in HEARTBEAT.md
4. **Connect team channels** — Add Slack/Discord for team communication
5. **Document in team/** — Add team-specific docs to `team/` directory

---

*For more details, see the [OpenClaw Documentation](https://docs.openclaw.ai)*
