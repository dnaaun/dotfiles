---
description: "jj git push - Push to a Git remote"
---

# jj git push

Push to a Git remote.

By default, pushes tracking bookmarks pointing to `remote_bookmarks(remote=<remote>)..@`. Use `--bookmark` to push specific bookmarks. Use `--all` to push all bookmarks. Use `--change` to generate bookmark names based on the change IDs of specific commits.

See: https://jj-vcs.github.io/jj/latest/bookmarks/#pushing-bookmarks-safety-checks

## Usage

```
jj git push [OPTIONS]
```

## Options

```
--remote <REMOTE>              The remote to push to (only named remotes are supported)
                               Defaults to the git.push setting, or "origin".

-b, --bookmark <BOOKMARK>      Push only this bookmark, or bookmarks matching a pattern

--all                          Push all bookmarks (including new bookmarks)

--tracked                      Push all tracked bookmarks

--deleted                      Push all deleted bookmarks

-N, --allow-new                Allow pushing new bookmarks

--allow-empty-description      Allow pushing commits with empty descriptions

--allow-private                Allow pushing commits that are private

-r, --revisions <REVSETS>      Push bookmarks pointing to these commits

-c, --change <REVSETS>         Push this commit by creating a bookmark

-h, --help                     Print help
```
