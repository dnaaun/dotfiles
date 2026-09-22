# jj-gh-review.nvim

GitHub pull-request **review comments** inside Neovim, for [jj](https://jj-vcs.github.io)
repositories. Threads show up as ghost text on the lines they refer to, and you read,
reply to, edit and create them in floating buffers that you save with `:w`.

Design principles:

- **jj only, never plain `git`.** Every `gh` call runs with `GIT_DIR="$(jj git root)"`,
  so it works in jj workspaces that are not colocated with a git checkout.
- **Offline first / optimistic UI.** The last fetched state of a PR is cached on disk and
  shown immediately on `:Review`; a refresh happens in the background. Every write
  (new comment, reply, edit, delete, resolve, submit) is applied locally at once, queued
  on disk, and pushed to GitHub in order with retries. The statusline shows all of it.
- **No default mappings.** The plugin exposes Lua functions; you bind them.

## Usage

```vim
:Review <specifier>     " anything `gh pr view` accepts: number, URL, head branch (empty = current branch)
:ReviewComment          " new comment on the current line / range (:'<,'>ReviewComment)
:ReviewClose            " end the session, clear ghost text
```

`:Review` will, in order:

1. show cached threads for that specifier (if any), then resolve the PR with `gh pr view`,
2. `jj git fetch --branch <head>` if the head commit is unknown locally,
3. `jj new <head commit>` unless the working copy already is an empty change on top of it,
4. run the configured diff view command (default `JjDiffviewOpen --from 'common_ancestor_with_main(@)'`),
5. fetch the review threads and render ghost text in every buffer showing a reviewed file.

Comments on the `RIGHT` side (PR head) attach to working-copy files. Comments on the
`LEFT` side (base) attach to `diffview://…/.jj/<commit>/<path>` buffers whose commit is
not the PR head. Outdated threads are shown (dimmed) at their original line.

## Lua API

```lua
local review = require("jj_gh_review")
review.setup({ ... })       -- optional; see lua/jj_gh_review/config.lua for every option
review.open(spec)           -- same as :Review
review.comment()            -- new comment on the cursor line, or the visual selection
review.view()               -- open the thread(s) on the cursor line in a float
review.next() / review.prev()
review.list()               -- all threads in the quickfix list
review.toggle_resolved()
review.delete_comment()     -- your comment under the cursor (inside a thread float)
review.open_in_browser()
review.submit_review()      -- prompts COMMENT / APPROVE / REQUEST_CHANGES + body
review.refresh()            -- re-fetch from GitHub
review.sync()               -- push queued changes now
review.drop_failed()        -- discard queued changes that keep failing
review.close()
review.statusline()         -- string for your statusline ("" when idle)
review.status()             -- the raw session table
```

Inside a thread float, saving the buffer (`:w`) applies what changed: edited bodies of
your own comments become edits, text under the trailing `### reply` header becomes a
reply. In a new-comment float the text under `### comment` becomes the comment. Edits
to other people's comments are ignored with a warning.

The `User JjGhReviewThreadBuffer` autocommand fires when a float opens
(`args.data.buf`, `args.data.win`) so you can add buffer-local mappings, and
`User JjGhReviewChanged` fires on every state change.

### Statusline

`review.statusline()` renders, e.g. ` #11230  1/3  2  1 (cached) syncing…`:
PR number, unresolved/total threads, comments in your unsubmitted review, queued local
operations, whether the data is still the cached copy, and the current phase or error.

## Development

```sh
make typecheck     # emmylua_check with Neovim + luv type definitions (downloads tools into deps/)
make format        # stylua
make test          # headless offline test with GitHub calls stubbed
make check         # what CI runs
```

CI lives in `.github/workflows/jj-gh-review.yml` at the repository root.
