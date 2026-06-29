---
name: confluence
description: Use confluence-cli to read, search, create, update, move, delete, and convert Confluence pages and attachments from the terminal.
argument-hint: <pageId, URL, search query, or task description>
allowed-tools: [Bash, Read, Write, Glob, Grep]
---

# confluence-cli Skill

A CLI tool for Atlassian Confluence. Lets you read, search, create, update, move, delete, and convert pages and attachments from the terminal or from an agent.

## Page ID Resolution

Most commands accept `<pageId>` — a numeric ID or any of the supported URL formats below.

**Supported formats:**

| Format | Example |
|---|---|
| Numeric ID | `123456789` |
| `?pageId=` URL | `https://company.atlassian.net/wiki/viewpage.action?pageId=123456789` |
| Pretty `/pages/<id>` URL | `https://company.atlassian.net/wiki/spaces/SPACE/pages/123456789/Page+Title` |
| Display `/display/<space>/<title>` URL | `https://company.atlassian.net/wiki/display/SPACE/Page+Title` |

```sh
confluence read 123456789
confluence read "https://company.atlassian.net/wiki/viewpage.action?pageId=123456789"
confluence read "https://company.atlassian.net/wiki/spaces/MYSPACE/pages/123456789/My+Page"
```

> **Note:** Display-style URLs (`/display/<space>/<title>`) perform a title-based lookup, so the page title in the URL must match exactly. When possible, prefer numeric IDs or `/pages/<id>` URLs for reliability.

## Content Formats

| Format | Notes |
|---|---|
| `markdown` | Recommended for agent-generated content. Automatically converted by the API. |
| `storage` | Confluence XML storage format (default for create/update). Use for programmatic round-trips. |
| `html` | Raw HTML. |
| `text` | Plain text — for read/export output only, not for creation. |

---

## Commands Reference

### `read <pageId>`

Read page content. Outputs to stdout.

```sh
confluence read <pageId> [--format html|text|storage|markdown]
```

| Option | Default | Description |
|---|---|---|
| `--format` | `text` | Output format: `html`, `text`, `storage`, or `markdown` |

```sh
confluence read 123456789
confluence read 123456789 --format storage
confluence read 123456789 --format markdown
```

---

### `info <pageId>`

Get page metadata. Use `--format json` for machine-readable output.

```sh
confluence info <pageId> [--format text|json]
```

```sh
confluence info 123456789
confluence info 123456789 --format json
```

---

### `find <title>`

Find a page by exact or partial title. Returns the first match.

```sh
confluence find <title> [--space <spaceKey>]
```

| Option | Description |
|---|---|
| `--space` | Restrict search to a specific space key |

```sh
confluence find "Architecture Overview"
confluence find "API Reference" --space MYSPACE
```

---

### `search <query>`

Search pages using a keyword or CQL expression.

```sh
confluence search <query> [--limit <number>] [--cql]
```

| Option | Default | Description |
|---|---|---|
| `--limit` | `10` | Maximum number of results |
| `--cql` | false | Pass query as raw CQL instead of text search |

```sh
confluence search "deployment pipeline"
confluence search --cql 'siteSearch ~ "deployment pipeline" and space = "MYSPACE"' --limit 50
```

---

### `spaces`

List all accessible Confluence spaces (key and name).

```sh
confluence spaces
```

---

### `children <pageId>`

List child pages of a page.

```sh
confluence children <pageId> [--recursive] [--max-depth <number>] [--format list|tree|json] [--show-id] [--show-url]
```

| Option | Default | Description |
|---|---|---|
| `--recursive` | false | List all descendants recursively |
| `--max-depth` | `10` | Maximum depth for recursive listing |
| `--format` | `list` | Output format: `list`, `tree`, or `json` |
| `--show-id` | false | Show page IDs |
| `--show-url` | false | Show page URLs |

```sh
confluence children 123456789
confluence children 123456789 --recursive --format json
confluence children 123456789 --recursive --format tree --show-id
```
---

### `export <pageId>`

Export a page and its attachments to a local directory.

```sh
confluence export <pageId> [--format html|text|markdown] [--dest <directory>] [--file <filename>] [--attachments-dir <name>] [--pattern <glob>] [--referenced-only] [--skip-attachments]
```

| Option | Default | Description |
|---|---|---|
| `--format` | `markdown` | Content format for the exported file |
| `--dest` | `.` | Base directory to export into |
| `--file` | `page.<ext>` | Filename for the content file |
| `--attachments-dir` | `attachments` | Subdirectory name for attachments |
| `--pattern` | — | Glob filter for attachments (e.g. `*.png`) |
| `--referenced-only` | false | Only download attachments referenced in the page content |
| `--skip-attachments` | false | Do not download attachments |

```sh
confluence export 123456789 --format markdown --dest ./docs
confluence export 123456789 --format markdown --dest ./docs --skip-attachments
confluence export 123456789 --pattern "*.png" --dest ./output
```

Creates a subdirectory named after the page title under `--dest`.

---

### `attachments <pageId>`

List or download attachments for a page.

```sh
confluence attachments <pageId> [--limit <n>] [--pattern <glob>] [--download] [--dest <directory>]
```

| Option | Default | Description |
|---|---|---|
| `--limit` | all | Maximum number of attachments to fetch |
| `--pattern` | — | Filter by filename glob (e.g. `*.pdf`) |
| `--download` | false | Download matching attachments |
| `--dest` | `.` | Directory to save downloads |

```sh
confluence attachments 123456789
confluence attachments 123456789 --pattern "*.pdf" --download --dest ./downloads
```

---

### `stats`

Show local usage statistics.

```sh
confluence stats
```

---

## Common Agent Workflows

### Search and process results

```sh
confluence search --cql 'siteSearch ~ "release notes" and space = "MYSPACE"' --limit 20
```

### Process children as JSON

```sh
confluence children 123456789 --recursive --format json | jq '.[].id'
```

---

## Agent Tips

- **Always use `--yes`** on destructive commands (`delete`, `comment-delete`, `attachment-delete`) to avoid interactive prompts blocking the agent.
- **Prefer `--format markdown`** when creating or updating content from agent-generated text — it's the most natural format and the API converts it automatically.
- **Use `--format json`** on `children` and `comments` for machine-parseable output.
- **ANSI color codes**: stdout may contain ANSI escape sequences. Pipe through `| cat` or use `NO_COLOR=1` if your downstream tool doesn't handle them.
- **Page ID vs URL**: when you have a Confluence URL, extract `?pageId=<number>` and pass the number. Do not pass pretty/display URLs — they are not supported.
- **Cross-space moves**: `confluence move` only works within the same space. Moving across spaces is not supported.
- **Multiple instances**: Use `--profile <name>` or `CONFLUENCE_PROFILE` env var to target different Confluence instances without reconfiguring.
- **Read-only mode**: Set `CONFLUENCE_READ_ONLY=true` or use `--read-only` when creating profiles to prevent accidental writes. This is enforced at the CLI level — all write commands will be blocked.

## Error Patterns

| Error | Cause | Fix |
|---|---|---|
| `No configuration found` | No config file and no env vars set | Set env vars or run `confluence init` |
| `Cross-space moves are not supported` | `move` used across spaces | Copy with `copy-tree` instead |
| 400 on inline comment creation | Editor metadata required | Use `--location footer` or reply to existing inline comment with `--parent` |
| `File not found: <path>` | `--file` path doesn't exist | Check the path before calling the command |
| `At least one of --title, --file, or --content must be provided` | `update` called with no content options | Provide at least one of the required options |
| `Profile "<name>" not found!` | Specified profile doesn't exist | Run `confluence profile list` to see available profiles |
| `Cannot delete the only remaining profile.` | Tried to remove the last profile | Add another profile before removing |
| `This profile is in read-only mode` | Write command used with a read-only profile | Use a writable profile or remove `readOnly` from config |

