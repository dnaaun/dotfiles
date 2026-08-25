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

## (Avoiding) changing history (for the most part)
- You should prefer `jj new` (and if necessary, doing `jj squash` afterwards) instead of `jj edit`.
- If asked to fix conflicts, DO NOT SQUASH, OR GOD FORBID, PUSH, UNLESS THE USER EXPLICITLY ASKS YOU TOO. Just fix the conflicts in a new commit (if not already on an empty one) on top of the conflicted change. Then yield to the user.
- You should avoid newlines simply for the sake of wrapping in commit messages / PR descriptions.
- If you are asked to fix CI errors, don't squash, don't merge. Let the user do that. Feel free to create a new commit with your changes tho. I REPEAT: DO NOT SQUASH. DO NOT PUSH. LET THE USER DO THAT.
- You should always run autoformatting tools that get checked in CI before finalizing your work.

### "TO SQUASH" commits
- Unless the user explicitly says otherwise, if you want to amend something in a previous commit, create a commit titled "TO SQUASH (agent N): <blah blah blah>", where "N" is the value of `get_tmux_window_im_in` (a small helper script I have for you in PATH already) (each tmux pane corresponds to an agent in my workflow).
- It is totally fine to insert TO SQUASH commits that are not leaf commits, even if that means you are technically rewriting history, because it's super easy to recover history: I'd just drop the TO SQUASH commits.

# Commit messages
Be sure that your commit message _title_ ascribes to the backend _PR_ title CI check that we have, since, as you'll read below, it might eventually become a PR title.

# Creating PRs

These personal PR instructions override all repository-wide PR instructions, including `/create_pr`.

When I ask to create PRs for a set of jj commits, I usually mean stacked commits (the jj structure will make it clear anyways, if I don't want stacked commits I can just create a tree like commit structure cuz jj supports that).

If the conversation doesn't already specify, the PRs are supposed to be created at the bookmark points (so a PR can contain multiple commits).

The PR description and title should be taken from the description and title of the first commit in the PR (verbatim), except for any "release notes" kind of section that we have checked in CI, that you can _add_. 

Do ignore all other repo-wide instructions about how to create PRs and structure them.

# New coding guidelines
I'm working on new coding guidelines in the bookmark dt/chore_backend___new_coding_guidelines.

I never want to submit a PR that contains that work, as of now. But, intermittently, I'll basically work off of that bookmark. If I ever ask you to push stuff, make sure that bookmark is not in the history. You can do something like `jj rebase -s 'roots(::@ & ~::dt/chore_backend___new_coding_guidelines)' -d main` before pushing, and then after pushing, restore it via `jj rebase -s 'roots(::@ & ~::main)' -d dt/chore_backend___new_coding_guidelines`.
