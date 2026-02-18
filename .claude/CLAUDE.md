 - You should first try to use jj before git, and only if jj reports it's not in a jj dir, go to use git.
 - I often use jj workspaces (in which git commands don't work without setting GIT_DIR). So do something like `GIT_DIR="$(jj git root)" gh ...` if you want to run gh commands.
 - You have a jujutsu_or_jj skill. Use it.

- When fixing CI/linting errors, you should try to first see if there's some formatter/linter/fixer you can run to fix the issues before attempting to fix it by writing to files yourself.

- You should prefer `jj new` (and if necessary, doing `jj squash` afterwards) instead of `jj edit`.
