# digest-and-improve - Content Digest and Self-Improvement

**Purpose:** Digest external content (articles, tweets, etc.) and identify self-improvement opportunities.

## When to Use

When Rudy provides a link to external content (Twitter, blog post, etc.) and requests:
1. Digest the content into a markdown summary
2. Identify what can be learned/learned for self-improvement
3. Create a proposal in the appropriate RLT

## Step 1: Fetch Content

### Priority: Get the content

**Method 1: Web Fetch (for articles/blog posts)**
```bash
web_fetch --url <url> --extract-mode markdown
```

**Method 2: Browser (for Twitter/Social Media)**
```bash
# Start browser with chrome profile
browser start --profile chrome

# Navigate to URL
browser navigate --target-url <url>

# Take snapshot to read content
browser snapshot
```

**Method 3: Ask Rudy for content (if fetch fails)**
If web_fetch and browser both fail, ask Rudy to:
- Copy-paste the content directly
- Provide a screenshot
- Share the content in an alternative format

## Step 2: Write Digest (Markdown)

Create file: `docs/twitter/<YYYY-MM-DD>-<title-slug>.md`

**Format:**

```markdown
# <Title>

**Source:** <URL>
**Author:** <Author>
**Date:** <YYYY-MM-DD>

## Summary

[2-3 paragraph summary of the main points]

## Key Points

- [Key point 1]
- [Key point 2]
- [Key point 3]
- ...

## Quotes

> [Notable quote 1]

> [Notable quote 2]

## My Takeaways

[Your thoughts and analysis]
```

**Naming convention:**
- Date: YYYY-MM-DD
- Title slug: lowercase, hyphens instead of spaces
- Example: `2026-02-12-building-agents-system.md`

## Step 3: Identify Self-Improvement Opportunities

### Questions to Ask

1. **What new practices/methods can I adopt?**
   - Coding patterns
   - Documentation standards
   - Communication style

2. **What can improve my current tasks?**
   - RLT-xxx workflows
   - Skill implementations
   - Tool usage

3. **What gaps do I have?**
   - Missing capabilities
   - Areas where I fall short
   - Things I should know but don't

4. **What can be automated/streamlined?**
   - Manual processes
   - Repetitive tasks
   - Decision points

## Step 4: Create Proposal in RLT

### RLT Selection Rules

Choose the most relevant RLT:

- **If related to existing task:** Add proposal to that task
- **If new area:** Create new RLT task (discuss with Rudy first)

### Proposal Format

Add to `tasks/RLT-XXX/PROPOSAL.md` (or create the file):

```markdown
# Proposal: [Title]

## Source

- **Content:** <digest file path>
- **Date:** <YYYY-MM-DD>

## Problem

[What problem does this proposal solve?]

## Proposed Solution

[Detailed proposal]

### Implementation Steps

1. [Step 1]
2. [Step 2]
3. [Step 3]

### Expected Benefits

- [Benefit 1]
- [Benefit 2]

### Effort Estimate

- [Low/Medium/High]
- [Estimated time: X hours/days]

## Questions for Rudy

- [Question 1]
- [Question 2]
```

## Step 5: Commit and Notify

1. **Commit all changes:**
   ```bash
   git add docs/twitter/ tasks/RLT-XXX/PROPOSAL.md
   git commit -m "Digest: <title>"
   git push
   ```

2. **Notify Rudy:**
   ```
   已完成 digest 和 proposal：
   - Digest: <digest file path>
   - Proposal: <RLT-XXX/PROPOSAL.md>
   ```

## Examples

### Example 1: Twitter Thread about Agent Systems

**Digest:** `docs/twitter/2026-02-12-building-agents-system.md`

**Analysis:**
- The thread discusses multi-agent architectures
- Mentions skill-based modularity
- Talks about configuration management

**Proposal (added to RLT-011):**
- Propose adding configuration validation skill
- Propose creating agent health monitoring system

### Example 2: Article about Code Review Best Practices

**Digest:** `docs/twitter/2026-02-12-code-review-tips.md`

**Analysis:**
- Emphasizes incremental reviews
- Suggests using checklists
- Recommends automated tools

**Proposal (new RLT-015):**
- Create code-review-checklist skill
- Add automated PR summary generation
- Implement code quality scoring

## Notes

- **Create docs/twitter/ directory** if it doesn't exist
- **Keep digests concise** - focus on actionable insights
- **Prioritize RLT proposals** - what can actually improve my work?
- **Always ask Rudy** before creating new RLT tasks
- **Git push** after completing all steps

## After Proposal

- Wait for Rudy's feedback
- Implement approved proposals
- Track progress in RLT task notes
- Update proposal with implementation notes
