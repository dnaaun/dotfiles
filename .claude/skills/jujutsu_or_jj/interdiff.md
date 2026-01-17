---
description: "jj interdiff - Compare the changes of two commits"
---

# jj interdiff

Compare the changes of two commits.

This excludes changes from other commits by temporarily rebasing `--from` onto `--to`'s parents. If you wish to compare the same change across versions, consider `jj evolog -p` instead.

## Usage

```
jj interdiff [OPTIONS] <--from <REVSET>|--to <REVSET>> [FILESETS]...
```

## Arguments

- `[FILESETS]...` - Restrict the diff to these paths

## Options

```
-f, --from <REVSET>   Show changes from this revision
-t, --to <REVSET>     Show changes to this revision
-h, --help            Print help
```

## Diff Formatting Options

```
-s, --summary               For each path, show only whether it was modified, added, or deleted
--stat                      Show a histogram of the changes
--types                     For each path, show only its type before and after
--name-only                 For each path, show only its path
--git                       Show a Git-format diff
--color-words               Show a word-level diff with changes indicated only by color
--tool <TOOL>               Generate diff by external command
--context <CONTEXT>         Number of lines of context to show
-w, --ignore-all-space      Ignore whitespace when comparing lines
-b, --ignore-space-change   Ignore changes in amount of whitespace
```
