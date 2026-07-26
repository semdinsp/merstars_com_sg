# Claude Code Configuration

## Project
Elixir/Phoenix website (`merstars_com_sg`). Phoenix LiveView + Ecto/Postgres, esbuild/tailwind for assets.

## Project Commands
- Setup: `mix setup`
- Run dev server: `mix phx.server` (or `iex -S mix phx.server`)
- Run tests: `mix test`
- Format: `mix format`
- Compiler warnings as errors: `mix compile --warnings-as-errors`
- Full pre-commit check (compile strict, unused deps, format, test): `mix precommit`

## Git Workflow

### Branching
- Never commit directly to `main`
- Create a branch before starting any task: `git checkout -b claude/<short-description>`
  Examples: `claude/fix-copyright-year`, `claude/add-phone-to-nav`
- One branch per logical task. If a task has multiple unrelated changes, split into separate branches.

### Commits
- Use atomic commits with clear messages: `[Claude] <imperative verb> <what>`
  Example: `[Claude] Add phone number to header and footer`
- Commit as you go — don't batch everything into one commit at the end

### Finishing a task
When the task is complete:
1. Run the test suite: `mix test`
2. Check for compiler warnings: `mix compile --warnings-as-errors`
3. Push the branch: `git push origin HEAD`
4. Print a summary with:
   - Branch name
   - Files changed and why
   - Any assumptions made
   - Any follow-up items or risks to review
5. Do NOT merge into main. Do NOT open a PR unless asked.

### Self-review before pushing
Before pushing, run `/review`
- No debug code, no hardcoded secrets, no commented-out blocks
- No unintended files changed
- Migrations are present if schema changed
- No changes outside the scope of the task

### Never
- Force-push to main
- Rebase main
- Merge without developer review

## Notes
Add any project-specific information, commands, or preferences here.
