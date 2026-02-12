# Project: Bookmark Intelligence Skill (Open Source Clone)

## Reference
- Source: <https://github.com/openclaw/skills/blob/main/skills/bkrigmo1/bookmark-intelligence/>
- Pricing: Free (10/mo), Pro ($9/mo), Enterprise ($29/mo)
- Goal: Build open-source version to avoid subscription

## Features to Implement

### Core Functionality
1. **Daily Bookmark Monitoring**
   - Use `bird CLI` to fetch X bookmarks automatically
   - Cron job: Daily execution (e.g., 9:00 AM daily)

2. **Content Fetching**
   - Extract URLs from bookmarked tweets
   - Fetch full content from linked articles (web_fetch)

3. **AI Analysis**
   - Analyze bookmarked content with local LLM
   - Identify key insights, patterns, themes
   - Relate insights to user's projects/context

4. **Digest & Proposal**
   - Generate daily digest of bookmarked content
   - Identify actionable ideas/improvements
   - Write proposals to RLT (tech/design/life/business)

5. **Notification**
   - Send digest via Telegram/Slack
   - Configurable channels and timing

## Implementation Plan

### Phase 1: Data Collection
- [ ] Setup bird CLI integration
- [ ] Test bookmark fetch (bird bookmarks)
- [ ] Parse tweets and extract URLs
- [ ] Fetch article content from URLs

### Phase 2: AI Processing
- [ ] Design analysis prompt
- [ ] Process content with local LLM
- [ ] Extract insights and actionable items

### Phase 3: RLT Integration
- [ ] Generate proposal format
- [ ] Auto-write to rlt/<category>/YYYY-MM-DD.md
- [ ] Commit and push changes

### Phase 4: Scheduling & Notification
- [ ] Create cron job for daily execution
- [ ] Add Slack/Telegram notification
- [ ] Add manual trigger option

## Dependencies
- `bird` CLI (already installed, v0.8.0)
- `web_fetch` (OpenClaw tool)
- Local LLM (zai/glm-4.7 or anthropic/claude-opus-4-5)
- Cron jobs (OpenClaw cron tool)

## File Structure
```
skills/bookmark-intelligence/
├── SKILL.md                    # Skill documentation
├── bin/
│   ├── fetch-bookmarks.js      # Main script
│   └── analyze-content.js      # AI analysis
└── templates/
    └── proposal.md             # Proposal template
```

## Success Criteria
- [ ] Daily bookmark digest generated automatically
- [ ] Actionable proposals written to RLT
- [ ] Notifications sent to Slack/Telegram
- [ ] Zero subscription cost (fully open-source)
- [ ] Configurable schedule and channels

---

**Created:** 2026-02-13
**Priority:** High (saves subscription cost, enables personal knowledge workflow)
