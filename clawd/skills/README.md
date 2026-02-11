# Skills Directory

> ✏️ CUSTOM - 此目录由 Team 自定义

Place your team-specific skills here.

## Skill Structure

```
skills/
└── my-skill/
    ├── SKILL.md      # Skill definition and instructions
    ├── knowledge/    # Knowledge base (optional)
    ├── scripts/      # Helper scripts (optional)
    └── templates/    # Output templates (optional)
```

## Creating a Skill

1. Create a directory: `mkdir skills/my-skill`
2. Add `SKILL.md` with:
   - YAML frontmatter (name, version, description, tags)
   - Role definition
   - Operating rules
   - Workflow instructions

## Example SKILL.md

```markdown
---
name: my-skill
version: 1.0
description: Short description of what this skill does
tags: [tag1, tag2]
---

# My Skill

## Role Definition
What is this skill for?

## Operating Rules
1. Rule one
2. Rule two

## Workflow
Step-by-step instructions...
```

## Tips

- Keep skills focused on one capability
- Include clear triggers (when to use)
- Document any external dependencies
- Add knowledge files for domain-specific info
