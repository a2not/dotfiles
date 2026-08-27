---
name: ketch
description: Use the ketch CLI to search the web via the local SearXNG instance. Trigger for research questions, "search the web", "look up X", current events, or when external sources are needed. Not for local codebase search.
argument-hint: <search query>
allowed-tools: [Bash]
---

# ketch web search

Use `ketch` for web search through the local SearXNG instance at `http://127.0.0.1:18188`.

## Basic search

```sh
ketch search "<query>" --json [--limit N]
```

Default limit is 5. Use `--limit 5` for quick checks, `--limit 20` for broader research.

## Verify the setup

If search fails:

```sh
ketch config
ketch doctor
```

Expected: `backend: searxng`, `searxng_url: http://127.0.0.1:18188`. If not, report a config issue; do not mutate config without explicit user confirmation.

## Error handling

| Exit | Prefix | Meaning | Action |
|---|---|---|---|
| 2 | `[validation]` | Bad input | Fix query/flags |
| 3 | `[not_found]` | No results | Rephrase the query |
| 4 | `[upstream]` | Backend/network failure | Retry once; persistent failure likely means SearXNG is down |
| 5 | `[precondition]` | Missing config | Stop and report setup issue |
| 6 | `[cancelled]` | Cancelled | Retry with smaller scope |

## Rules

- Prefer `ketch search` over `webfetch` for broad research with multiple sources.
- Always cite the source URL for every claim.
- Use `--json` on every call.
- Do not run `ketch config set` or install software without explicit user confirmation.
