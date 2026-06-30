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


