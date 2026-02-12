# Confluence Writer Skill

Write and update Confluence pages following InfStones formatting standards.

## When to Use

- Writing new Confluence pages
- Converting Markdown files to Confluence format
- Updating existing Confluence pages

## Confluence API

**Authentication:** Basic auth with email + API token
```bash
curl -u "email:api_token" "https://infstones.atlassian.net/wiki/api/v2/..."
```

**Get page (with content):**
```bash
curl -s -u "$EMAIL:$TOKEN" \
  "https://infstones.atlassian.net/wiki/api/v2/pages/{PAGE_ID}?body-format=storage"
```

**Update page:**
```bash
curl -s -X PUT -u "$EMAIL:$TOKEN" \
  -H "Content-Type: application/json" \
  "https://infstones.atlassian.net/wiki/api/v2/pages/{PAGE_ID}" \
  -d '{
    "id": "{PAGE_ID}",
    "status": "current",
    "title": "Page Title",
    "body": {
      "representation": "storage",
      "value": "<confluence-storage-format-html>"
    },
    "version": {
      "number": {CURRENT_VERSION + 1}
    }
  }'
```

**Create page:**
```bash
curl -s -X POST -u "$EMAIL:$TOKEN" \
  -H "Content-Type: application/json" \
  "https://infstones.atlassian.net/wiki/api/v2/pages" \
  -d '{
    "spaceId": "{SPACE_ID}",
    "status": "current",
    "title": "Page Title",
    "body": {
      "representation": "storage",
      "value": "<confluence-storage-format-html>"
    }
  }'
```

## InfStones Formatting Standards

Reference: https://infstones.atlassian.net/wiki/spaces/COM/pages/94208146/Confluence+Document+Formatting+Guide

### 1. Table of Contents

**ALWAYS start every page with TOC macro:**
```html
<ac:structured-macro ac:name="toc" ac:schema-version="1">
  <ac:parameter ac:name="style">none</ac:parameter>
</ac:structured-macro>
```

### 2. No Horizontal Rules

**DO NOT use `<hr/>` or any dividers.** InfStones never uses horizontal rules.

### 3. Headings

**Format:** Number + Space + Title (NO bold on headings)

| Level | Tag | Format | Example |
|-------|-----|--------|---------|
| H1 | `<h1>` | `1 Title` | `<h1>1 Directory Structure</h1>` |
| H2 | `<h2>` | `1.1 Title` | `<h2>1.1 Overview</h2>` |
| H3 | `<h3>` | `1.1.1 Title` | `<h3>1.1.1 Details</h3>` |

**Rules:**
- H1: `1`, `2`, `3`...
- H2: `1.1`, `1.2`, `2.1`...
- H3: `1.1.1`, `1.1.2`...
- Generally only use H1, H2, H3 (no deeper)

### 4. Items Under Headings

**Use `a)`, `b)`, `c)` for parallel items** (NOT `1.`, `2.`, `3.`):
```html
<p><strong>a) Purpose:</strong> Description here</p>
<p><strong>b) When loaded:</strong></p>
<ul>
  <li><p>Bullet point 1</p></li>
  <li><p>Bullet point 2</p></li>
</ul>
<p><strong>c) Contents:</strong> More description</p>
```

### 5. Bullet Lists

Use `<ul><li><p>...</p></li></ul>` for sub-items under `a)`, `b)`, `c)`:
```html
<p><strong>b) When loaded:</strong></p>
<ul>
  <li><p>✅ Every session start</p></li>
  <li><p>❌ Not loaded in shared sessions</p></li>
</ul>
```

### 6. Code Blocks

Use Confluence code macro with wide breakout:
```html
<ac:structured-macro ac:name="code" ac:schema-version="1">
  <ac:parameter ac:name="language">bash</ac:parameter>
  <ac:parameter ac:name="breakoutMode">wide</ac:parameter>
  <ac:parameter ac:name="breakoutWidth">760</ac:parameter>
  <ac:plain-text-body><![CDATA[your code here]]></ac:plain-text-body>
</ac:structured-macro>
```

**Important:** Split code into multiple blocks so each can be copy-pasted directly.

### 7. Inline Code

Use `<code>` tag:
```html
<p>The file <code>MEMORY.md</code> contains sensitive data.</p>
```

### 8. Tables

Use Confluence table format:
```html
<table data-table-width="760" data-layout="default">
  <tbody>
    <tr>
      <th><p>Header 1</p></th>
      <th><p>Header 2</p></th>
    </tr>
    <tr>
      <td><p>Cell 1</p></td>
      <td><p>Cell 2</p></td>
    </tr>
  </tbody>
</table>
```

### 9. Links

```html
<a href="https://example.com">Link text</a>
```

### 10. Bold and Emphasis

```html
<strong>Bold text</strong>
<em>Italic text</em>
```

## Markdown to Confluence Conversion

When converting Markdown to Confluence:

| Markdown | Confluence |
|----------|------------|
| `# Title` | `<h1>1 Title</h1>` (add number) |
| `## Section` | `<h2>1.1 Section</h2>` (add number) |
| `---` | **DELETE** (no horizontal rules) |
| `1. Item` | `<p>a) Item</p>` (use letters) |
| `- Bullet` | `<ul><li><p>Bullet</p></li></ul>` |
| `` `code` `` | `<code>code</code>` |
| `**bold**` | `<strong>bold</strong>` |
| `[text](url)` | `<a href="url">text</a>` |
| Code fence | `<ac:structured-macro ac:name="code">...` |

## Workflow

1. **Read source content** (Markdown file or existing page)
2. **Get current page version** (if updating)
3. **Convert to Confluence storage format:**
   - Add TOC at top
   - Number all headings (1, 1.1, 1.1.1...)
   - Remove horizontal rules
   - Convert numbered lists to a), b), c)
   - Wrap code in Confluence macros
4. **Build JSON payload**
5. **POST/PUT to Confluence API**
6. **Verify success**

## Example: Complete Page Structure

```html
<ac:structured-macro ac:name="toc" ac:schema-version="1">
  <ac:parameter ac:name="style">none</ac:parameter>
</ac:structured-macro>
<p>Brief introduction paragraph.</p>
<h1>1 First Section</h1>
<p>Section intro.</p>
<h2>1.1 Subsection</h2>
<p><strong>a) Purpose:</strong> Description</p>
<p><strong>b) Details:</strong></p>
<ul>
  <li><p>Point one</p></li>
  <li><p>Point two</p></li>
</ul>
<h2>1.2 Another Subsection</h2>
<ac:structured-macro ac:name="code" ac:schema-version="1">
  <ac:parameter ac:name="language">bash</ac:parameter>
  <ac:parameter ac:name="breakoutMode">wide</ac:parameter>
  <ac:parameter ac:name="breakoutWidth">760</ac:parameter>
  <ac:plain-text-body><![CDATA[echo "Hello World"]]></ac:plain-text-body>
</ac:structured-macro>
<h1>2 Second Section</h1>
<table data-table-width="760" data-layout="default">
  <tbody>
    <tr>
      <th><p>Column A</p></th>
      <th><p>Column B</p></th>
    </tr>
    <tr>
      <td><p>Value 1</p></td>
      <td><p>Value 2</p></td>
    </tr>
  </tbody>
</table>
```

## Credentials

Confluence credentials are stored in `~/.secrets.json` or TOOLS.md. Use:
- **Email:** From Jira/Confluence account
- **API Token:** Atlassian API token (same as Jira)
- **Base URL:** `https://infstones.atlassian.net/wiki`
