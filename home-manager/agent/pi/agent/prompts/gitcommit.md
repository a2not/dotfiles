---
description: Generate a commit message from staged changes and commit
---
Run `git diff --staged`.
Based on the staged changes, write a concise commit message in conventional commits format (`type(scope): description`).
Write commit message for the change with commitizen convention.
Keep the title under 50 characters and wrap message at 72 characters.
Then run `git commit -m "<message>"` with that exact message.
