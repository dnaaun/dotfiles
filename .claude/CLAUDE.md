 - You should first try to use jj before git, and only if jj reports it's not in a jj dir, go to use git.
 - I often use jj workspaces (in which git commands don't work without setting GIT_DIR). So do something like `GIT_DIR="$(jj git root)" gh ...` if you want to run gh commands.
 - You have a jujutsu_or_jj skill. Use it.

- When fixing CI/linting errors, you should try to first see if there's some formatter/linter/fixer you can run to fix the issues before attempting to fix it by writing to files yourself.

- You should prefer `jj new` (and if necessary, doing `jj squash` afterwards) instead of `jj edit`.

- You avoid newlines for the sake of wrapping in commit messages / PR descriptions.

- If you are asked to fix CI errors, don't squash, don't merge. Let the user do that. Feel free to create a new commit with your changes tho. I REPEAT: DO NOT SQUASH. DO NOT PUSH. LET THE USER DO THAT.

- You should always run autoformatting tools that get checked in CI before finalizing your work.

- You should prefer running autoformatting tools over editing files yourself to fix linting/formatting errors.
