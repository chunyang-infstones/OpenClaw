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
├── AGENTS.md          # Workspace rules (DO NOT MODIFY)
├── BOOTSTRAP.md       # First-run instructions (DO NOT MODIFY)
├── SOUL.md            # Agent identity & principles
├── USER.md            # User profile
├── TOOLS.md           # Local tool configurations
├── HEARTBEAT.md       # Periodic task checklist
├── memory/            # Daily logs
├── skills/            # Agent skills
├── scripts/           # Utility scripts
├── canvas/            # Canvas assets
└── team/              # Team workspace (your files go here)
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

## Step 5: Customize Your Agent

### 5.1 Edit SOUL.md

Fill in the **Identity** section:
```markdown
## Identity (EDIT BELOW)

- **Name:** [Your agent's name]
- **Team:** [Team ID, e.g., dev-dos, pro-pog]
- **Creature:** AI assistant
- **Emoji:** [Signature emoji]
- **Avatar:** [Optional avatar URL]
```

Fill in the **Team Customization** section:
- Role Definition
- Personality & Tone
- Special Rules
- Decision Authority

### 5.2 Edit USER.md

Add information about the primary user:
- Name, role, timezone
- Communication preferences
- Key projects or responsibilities

### 5.3 Edit TOOLS.md (Optional)

Add any local tool configurations:
- Camera names
- SSH hosts
- Voice preferences
- API endpoints

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

Send this to trigger the bootstrap process:

```
Hello! I'm ready to begin. Please read BOOTSTRAP.md and complete the onboarding process.
```

The agent will:
1. Read BOOTSTRAP.md
2. Read and understand SOUL.md
3. Introduce itself
4. Delete BOOTSTRAP.md (it's no longer needed)
5. Start normal operation

---

## Step 8: Connect Channels (Optional)

### Slack

1. Create a Slack app at https://api.slack.com/apps
2. Add Bot Token Scopes: `chat:write`, `channels:history`, `groups:history`, `im:history`, `reactions:write`
3. Install to workspace
4. Add to OpenClaw config:

```bash
openclaw config
```

Add under `channels.slack`:
```json
{
  "slack": {
    "enabled": true,
    "mode": "socket",
    "accounts": {
      "default": {
        "botToken": "xoxb-...",
        "appToken": "xapp-..."
      }
    }
  }
}
```

### Discord

1. Create a Discord app at https://discord.com/developers/applications
2. Create a bot and get the token
3. Add to OpenClaw config under `channels.discord`

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
