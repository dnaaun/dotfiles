# Personal instructions precedence

These are my personal preferences, and they should override any repo-wide instruction you get. Since everything goes through PR review, if there's a strong conflict, it will be caught at review time anyways.

# JJ setup

I, personally, use jj for VCS (unlike the rest of my team, and many of the instructions you'll see in the repo).

 - You should first try to use jj before git, and only if jj reports it's not in a jj dir, go to use git.
 - I often use jj workspaces (in which git commands don't work without setting GIT_DIR). So do something like `GIT_DIR="$(jj git root)" gh ...` if you want to run gh commands.

- jj has great, progressively disclosed docs. Do jj --help or jj squash --help etc.
- When fixing CI/linting errors, you should try to first see if there's some formatter/linter/fixer you can run to fix the issues before attempting to fix it by writing to files yourself.

- You should prefer running autoformatting tools over editing files yourself to fix linting/formatting errors.

- Don't attempt to run `git mv` in a jj workspace. It won't work.

- Whenever you're done with a commit, do `jj new` on top of it so that I don't accidentally clobber your work.

## Changing history
- You should prefer `jj new` (and if necessary, doing `jj squash` afterwards) instead of `jj edit`.
- To amend a previous commit, squash the fix straight into it (`jj squash --into`, or a fixup and rebase in git). Don't leave separate "fix up later" commits.
- You may squash, rebase and push (force-push with lease for rewritten branches) without asking first, including when fixing conflicts or CI errors.
- You should avoid newlines simply for the sake of wrapping in commit messages / PR descriptions.
- You should always run autoformatting tools that get checked in CI before finalizing your work.

# Running tests

- Never run a full test suite locally. Run only the single test, or the single test file, that you changed or that covers your change.
- Leave wider suites to CI: push and read the CI result.
- If a test is slow or you are stuck fighting it for more than a few rounds, stop, tell me, and iterate in CI instead.

# Commit messages
Be sure that your commit message _title_ ascribes to the backend _PR_ title CI check that we have, since it might eventually become a PR title.

# Creating PRs

These personal PR instructions override all repository-wide PR instructions, including `/create_pr` (you can pretty much TOTALLY IGNORE the `/create_pr` command).

When I ask to create PRs for a set of jj commits, I usually mean stacked commits (the jj structure will make it clear anyways, if I don't want stacked commits I can just create a tree like commit structure cuz jj supports that).

If the conversation doesn't already specify, the PRs are supposed to be created at the bookmark points (so a PR can contain multiple commits).

The title has to pass the backend PR title CI check, and you should add any "release notes" kind of section that we have checked in CI.

Do ignore all other repo-wide instructions about how to create PRs and write descriptions for them.

If you have to create bookmarks yourself, use `jj_bkmark`, which is an alias I defined which will take the commit msg and make a bookmark from that.

Channel Blaise Pascal: spend time making PR and commit descriptions shorter. Omit details that are obvious consequences of anything else that will already be mentioned. Assume that your reader is an extremely competent SWE who is extremely familiar with the product surface, but only vaguely familiar with the code architecture and organization.

## Stacked PRs
Github has first-class support for PR stacks now. Use it whenever possible.
