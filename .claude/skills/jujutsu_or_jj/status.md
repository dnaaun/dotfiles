---
description: "jj status - Show high-level repo status [alias: st]"
---

# jj status

Show high-level repo status.

This includes:
- The working copy commit and its parents, and a summary of the changes in the working copy (compared to the merged parents)
- Conflicts in the working copy
- Conflicted bookmarks (see: https://jj-vcs.github.io/jj/latest/bookmarks/#conflicts)

## Usage

```
jj status [OPTIONS] [FILESETS]...
```

## Arguments

- `[FILESETS]...` - Restrict the status display to these paths

## Options

```
-h, --help    Print help
```
