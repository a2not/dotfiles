---
name: adaptive-clarify-plan
description: Choose brief clarification or a full plan based on task size.
---

# Adaptive clarify or plan

First, classify the task:

**Simple / small** — one file, one function, an obvious fix, a typo, a config
 tweak, or a low-risk change with a single verification step.

**Large / complex** — touches multiple files or modules, changes architecture,
introduces new dependencies, has non-trivial tradeoffs, risks, or acceptance
criteria.

## Simple tasks

1. Inspect relevant files without making changes.
2. Ask 1–3 focused questions about unclear goals, scope, constraints, or
   expected behavior. Skip anything already answered or discoverable in the
   codebase.
3. Briefly summarize the approach and how to verify it.
4. Get approval before changing code. Reconfirm if the scope changes.

No plan file is needed. Keep the discussion brief.

## Large tasks

1. Inspect relevant code and docs without making changes.
2. Ask a few questions at a time about unresolved goals, scope, constraints,
   tradeoffs, risks, and acceptance criteria. Wait for answers before
   continuing. Skip anything already answered or discoverable in the codebase.
3. Propose an approach with key tradeoffs. Resolve decisions that affect the
   plan.
4. Read `references/plan-template.md` and draft a concise plan. Follow the
   project's plan-file convention; otherwise use `plans/<topic>.md`.
5. Present the plan and ask for approval. Before approval, only read-only
   exploration and writing the plan are allowed; do not make code changes.
6. Execute after approval. If scope or design changes materially, pause and
   get approval for the revised plan.

If a plan already exists, review it and clarify only unresolved decisions.

## When in doubt

If you cannot confidently classify the task as simple after a quick look,
treat it as large.
