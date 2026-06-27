# AGENTS

Plan, clarify, then act.
Prefer simple, secure, robust solutions that fit well within the existing codebase and conventions.
Never edit generated files.
Never edit gitignored files.

## Plan, Clarify, then Execute

For any non-trivial task:

1. **Clarify first.** Ask the user any necessary clarifying questions to resolve ambiguity, confirm assumptions, and surface missing requirements. If the task references a ticket or PR, read it in full first. Never write a plan with unknowns unaddressed.
2. **Write the plan.** After clarity, write a concise plan as markdown in `PLAN.md` at the current project root. If the plan is intended for a fresh agent to pick up, use `/skill:handoff` instead. Pause after writing. Do not execute until the user approves it.
3. **Execute.** After approval, implement the plan. Update `PLAN.md` to mark completed items if useful.

A plan is markdown with:

- Goal (one sentence)
- Files to change
- Steps in order
- Open questions, if any

Keep plans short. Delete `PLAN.md` when the task is done if the user prefers a clean tree.

## Skills

opencode loads skills automatically, but full instructions are fetched on-demand. Use `/skill:name` to force-load a skill when a task matches its trigger.

Installed skills to reach for:

### Engineering
- `/skill:codebase-design` — shared vocabulary for designing deep modules, seams, and testable interfaces.
- `/skill:domain-modeling` — build and sharpen a project's domain model and ubiquitous language.
- `/skill:tdd` — test-driven development with tracer bullets and vertical slicing.
- `/skill:implement` — implement work from a PRD or issues; uses `/tdd` and `/review`.
- `/skill:grill-with-docs` — interview-style session to sharpen plans and produce ADRs / glossary.

### Workflow & Productivity
- `/skill:handoff` — compact the current conversation into a handoff document for a fresh agent.
- `/skill:pi-subagents` — delegation and multi-step workflows via subagents, chains, and parallel tasks.
- `/skill:librarian` — library internals and source-code research with GitHub permalinks.
- `/skill:confluence` — Confluence page operations (loaded from `~/.config/opencode/skills`).

### Context Management (`ctx-*`)
- `/skill:context-mode` — large outputs, logs, indexing, search, stats, doctor, purge, upgrade.
- `/skill:ctx-doctor` — run context-mode diagnostics (runtimes, hooks, FTS5, versions).
- `/skill:ctx-index` — index files/directories into the persistent FTS5 knowledge base.
- `/skill:ctx-search` — search the indexed knowledge base for focused snippets.
- `/skill:ctx-stats` — show token savings and consumption for this session.
- `/skill:ctx-purge` — wipe the context-mode knowledge base permanently.
- `/skill:ctx-upgrade` — update context-mode from GitHub and fix hooks/settings.
- `/skill:ctx-insight` — open the hosted analytics dashboard for AI-assisted engineering teams.

### Ponytail (`ponytail:*`)
- `/skill:ponytail` — minimal, lazy solutions. YAGNI, stdlib-first, shortest diff wins.
- `/skill:ponytail-review` — code review focused on over-engineering and what to delete.
- `/skill:ponytail-audit` — whole-repo audit for over-engineering and bloat.
- `/skill:ponytail-debt` — harvest `ponytail:` shortcut comments into a debt ledger.
- `/skill:ponytail-gain` — show ponytail's measured impact (code/cost/speed scoreboard).
- `/skill:ponytail-help` — quick-reference card for all ponytail modes and commands.

Use skills instead of reimplementing their behavior.

## Extensions

No custom extensions are currently installed for opencode.

# context-mode — MANDATORY routing rules

context-mode MCP tools available. Rules protect context window from flooding. One unrouted command dumps 56 KB into context.

## Think in Code — MANDATORY

Analyze/count/filter/compare/search/parse/transform data: **write code** via `context-mode_ctx_execute(language, code)`, `console.log()` only the answer. Do NOT read raw data into context. PROGRAM the analysis, not COMPUTE it. Pure JavaScript — Node.js built-ins only (`fs`, `path`, `child_process`). `try/catch`, handle `null`/`undefined`. One script replaces ten tool calls.

## BLOCKED — do NOT attempt

### curl / wget — BLOCKED
Shell `curl`/`wget` intercepted and blocked. Do NOT retry.
Use: `context-mode_ctx_fetch_and_index(url, source)` or `context-mode_ctx_execute(language: "javascript", code: "const r = await fetch(...)")`

### Inline HTTP — BLOCKED
`fetch('http`, `requests.get(`, `requests.post(`, `http.get(`, `http.request(` — intercepted. Do NOT retry.
Use: `context-mode_ctx_execute(language, code)` — only stdout enters context

### Direct web fetching — BLOCKED
Use: `context-mode_ctx_fetch_and_index(url, source)` then `context-mode_ctx_search(queries)`

## REDIRECTED — use sandbox

### Shell (>20 lines output)
Shell ONLY for: `git`, `mkdir`, `rm`, `mv`, `cd`, `ls`, `npm install`, `pip install`.
Otherwise: `context-mode_ctx_batch_execute(commands, queries)` or `context-mode_ctx_execute(language: "javascript", code: "...")`. Use `language: "shell"` only when code matches the host shell.

### File reading (for analysis)
Reading to **edit** → reading correct. Reading to **analyze/explore/summarize** → `context-mode_ctx_execute_file(path, language, code)`.

### grep / search (large results)
Use `context-mode_ctx_execute(language: "javascript", code: "...")` in sandbox for portable filtering/counting.

## Tool selection

0. **MEMORY**: `context-mode_ctx_search(sort: "timeline")` — after resume, check prior context before asking user.
1. **GATHER**: `context-mode_ctx_batch_execute(commands, queries)` — runs all commands, auto-indexes, returns search. ONE call replaces 30+. Each command: `{label: "header", command: "..."}`.
2. **FOLLOW-UP**: `context-mode_ctx_search(queries: ["q1", "q2", ...])` — all questions as array, ONE call (default relevance mode).
3. **PROCESSING**: `context-mode_ctx_execute(language, code)` | `context-mode_ctx_execute_file(path, language, code)` — sandbox, only stdout enters context.
4. **WEB**: `context-mode_ctx_fetch_and_index(url, source)` then `context-mode_ctx_search(queries)` — raw HTML never enters context.
5. **INDEX**: `context-mode_ctx_index(content, source)` — store in FTS5 for later search.

## Parallel I/O batches

For multi-URL fetches or multi-API calls, **always** include `concurrency: N` (1-8):

- `context-mode_ctx_batch_execute(commands: [3+ network commands], concurrency: 5)` — gh, curl, dig, docker inspect, multi-region cloud queries
- `context-mode_ctx_fetch_and_index(requests: [{url, source}, ...], concurrency: 5)` — multi-URL batch fetch

**Use concurrency 4-8** for I/O-bound work (network calls, API queries). **Keep concurrency 1** for CPU-bound (npm test, build, lint) or commands sharing state (ports, lock files, same-repo writes).

GitHub API rate-limit: cap at 4 for `gh` calls.

## Output

Write artifacts to FILES — never inline. Return: file path + 1-line description.
Descriptive source labels for `search(source: "label")`.

## Session Continuity

Skills, roles, and decisions persist for the entire session. Do not abandon them as the conversation grows.

## Memory

Session history is persistent and searchable. On resume, search BEFORE asking the user:

| Need | Command |
|------|---------|
| What did we decide? | `context-mode_ctx_search(queries: ["decision"], source: "decision", sort: "timeline")` |
| What constraints exist? | `context-mode_ctx_search(queries: ["constraint"], source: "constraint")` |

DO NOT ask "what were we working on?" — SEARCH FIRST.
If search returns 0 results, proceed as a fresh session.

## ctx commands

| Command | Action |
|---------|--------|
| `ctx stats` | Call `stats` MCP tool, display full output verbatim |
| `ctx doctor` | Call `doctor` MCP tool, run returned shell command, display as checklist |
| `ctx upgrade` | Call `upgrade` MCP tool, run returned shell command, display as checklist |
| `ctx purge` | Call `purge` MCP tool with confirm: true. Warns before wiping knowledge base. |

After /clear or /compact: knowledge base and session stats preserved. Use `ctx purge` to start fresh.

