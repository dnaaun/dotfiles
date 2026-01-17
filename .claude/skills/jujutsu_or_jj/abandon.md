---
description: "jj abandon - Abandon a revision"
---

# jj abandon

Abandon a revision, rebasing descendants onto its parent(s). The behavior is similar to `jj restore --changes-in`; the difference is that `jj abandon` gives you a new change, while `jj restore` updates the existing change.

If a working-copy commit gets abandoned, it will be given a new, empty commit.

## Usage

```
jj abandon [OPTIONS] [REVSETS]...
```

## Arguments

- `[REVSETS]...` - The revision(s) to abandon (default: @)

## Options

```
--retain-bookmarks       Do not delete bookmarks pointing to the revisions to abandon
                         Bookmarks will be moved to the parent revisions instead.

--restore-descendants    Do not modify the content of the children of the abandoned commits

-h, --help               Print help
```
