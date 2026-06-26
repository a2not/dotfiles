# Agent Instructions

Plan, then act.
Prefer simple, secure, robust solutions that fit the existing codebase and conventions.
Never edit generated files.
Never edit gitignored files.

## Plan then Execute

For any non-trivial task:

1. **Plan first.** Write the plan to `PLAN.md` in the current project root.
2. **Wait for confirmation.** Pause after writing the plan; do not execute until the user approves it.
3. **Execute.** After approval, implement the plan. Update `PLAN.md` to mark completed items if useful.

A plan is markdown with:

- Goal (one sentence)
- Files to change
- Steps in order
- Open questions, if any

Keep plans short. Delete `PLAN.md` when the task is done if the user prefers a clean tree.

## Skills

Pi loads skills automatically, but full instructions are fetched on-demand. Use `/skill:name` to force-load a skill when a task matches its trigger.

Installed skills to reach for:

- `/skill:context-mode` (and `/skill:ctx-*`) — large outputs, logs, indexing, search, stats, doctor, purge, upgrade.
- `/skill:ponytail` — minimal solutions; also `/skill:ponytail-review`, `/skill:ponytail-audit`, `/skill:ponytail-debt`.
- `/skill:pi-subagents` — delegation and multi-step workflows.
- `/skill:librarian` — library internals and source-code research.
- `/skill:confluence` — Confluence page operations (loaded from `~/.config/opencode/skills`).

Use skills instead of reimplementing their behavior.

