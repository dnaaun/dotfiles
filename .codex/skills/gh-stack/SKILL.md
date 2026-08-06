---
name: gh-stack
description: Publish jj-managed stacks as GitHub stacked PRs and manipulate GitHub stack state. Use for linking, restructuring, or merging stacked PRs. jj exclusively owns local commits, bookmarks, history, navigation, rebases, and pushes.
---

# GitHub stacks with jj

Assume full knowledge of jj and the standard `gh` CLI. This skill only documents the boundary between a jj-managed local stack and GitHub’s new stacked-PR state.

## Local-state boundary

Use jj exclusively for local repository operations. Available helpers include:

- `jj_bkmark <revset>` — create bookmarks at PR boundaries
- `jj_push <top-change>` — push the bookmarked stack through a change
- `jj_squash_onto_parents <revset>` — squash selected changes into their parents

Read their Bash source if exact behavior matters.

Never use the local-state features of `gh stack`, including `init`, `add`, `push`, `submit`, `sync`, `rebase`, `checkout`, `modify`, navigation, or `view`.

In jj workspaces, invoke GitHub commands with:

```bash
GIT_DIR="$(jj git root)" gh ...
```

## Publish a stack

Prepare and push the bookmark chain with jj. Create or update its PRs using normal `gh pr` commands and the user’s PR metadata rules.

Then communicate the stack structure to GitHub using PR numbers in bottom-to-top order:

```bash
GIT_DIR="$(jj git root)" gh stack link 41 42 43
```

For a non-default trunk:

```bash
GIT_DIR="$(jj git root)" gh stack link --base develop 41 42 43
```

Prefer PR numbers, not branch names. Branch arguments cause `gh stack link` to push refs and potentially create PRs with generated metadata, bypassing the jj workflow and the user’s title/body rules.

To append to an existing GitHub stack:

```bash
GIT_DIR="$(jj git root)" gh stack link <stack-number> <new-pr>...
```

## Restructure GitHub state

`gh stack link` is additive. To remove or reorder members, unstack the GitHub grouping and relink the surviving PRs:

```bash
GIT_DIR="$(jj git root)" gh stack unstack <stack-number>
GIT_DIR="$(jj git root)" gh stack link <pr>...
```

Always provide a stack number to `unstack`. It removes the GitHub grouping, not the PRs or remote branches. Queued or auto-merge-enabled PRs may remain stacked.

## Merge

Use `gh stack merge`, not `gh pr merge`. Always supply a stack or cutoff PR, `--yes`, and an explicit merge method:

```bash
GIT_DIR="$(jj git root)" gh stack merge <stack-number> --yes --squash
GIT_DIR="$(jj git root)" gh stack merge <cutoff-pr> --yes --squash
```

Verify checks, reviews, draft state, and intended scope first. `gh stack merge` itself checks only that included PRs are open and not drafts.

Without a merge queue, the operation is atomic: if any included PR cannot merge, none merge. With a merge queue, GitHub chooses the merge method and may process PRs in separate groups.

## Constraints

- GitHub stacks are linear.
- A PR cannot belong to multiple stacks.
- Linking cannot remove existing members.
- The repository must have stacked PRs enabled.
- GitHub mutations require user authorization; read-only inspection does not.
