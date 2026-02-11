# Scripts Directory

> ✏️ CUSTOM - 此目录由 Team 自定义

Place your team-specific scripts here.

## Common Scripts

- **Escalation scripts** — Send messages to Slack/Discord channels
- **API wrappers** — Simplify calls to external services
- **Automation helpers** — Cron job targets, batch processors

## Example: Slack Escalation Script

```bash
#!/bin/bash
# slack-escalate.sh - Send message to Slack channel

CHANNEL="${1:-C0XXXXXXX}"
MESSAGE="$2"
TOKEN="${SLACK_BOT_TOKEN:-$(jq -r '.SLACK_BOT_TOKEN' .secrets.json 2>/dev/null)}"

curl -s -X POST "https://slack.com/api/chat.postMessage" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"channel\": \"$CHANNEL\", \"text\": \"$MESSAGE\"}"
```

## Best Practices

- Make scripts executable: `chmod +x script.sh`
- Use environment variables or `.secrets.json` for credentials
- Add error handling and logging
- Document usage in comments
