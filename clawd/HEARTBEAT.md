# HEARTBEAT.md

> ✏️ CUSTOM - 此文件由 Team 自定义

# Keep this file empty (or with only comments) to skip heartbeat API calls.
# Add tasks below when you want the agent to check something periodically.

## Example Tasks

```markdown
# Uncomment and customize as needed:

## Check Slack for unread mentions
# - Scan #team-channel for questions
# - Reply or escalate as needed

## Monitor tickets
# - Check Jira/Discord for new tickets
# - Respond to user questions

## Daily summary
# - Compile activity from the day
# - Post to #daily-standup
```

## How Heartbeats Work

1. OpenClaw sends heartbeat polls at configured intervals
2. Agent reads this file and executes listed tasks
3. If nothing needs attention, reply `HEARTBEAT_OK`
4. Keep tasks small to limit token burn

## Tips

- Batch similar checks together
- Track last-check timestamps in `memory/heartbeat-state.json`
- Use cron jobs for time-sensitive tasks instead
