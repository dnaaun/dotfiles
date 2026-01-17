---
description: "jj diff - Compare file contents between two revisions"
---

# jj diff

Compare file contents between two revisions.

With the `-r` option, shows the changes compared to the parent revision. If there are several parent revisions (i.e., the given revision is a merge), then they will be merged and the changes from the result to the given revision will be shown.

With the `--from` and/or `--to` options, shows the difference from/to the given revisions. If either is left out, it defaults to the working-copy commit.

If no option is specified, it defaults to `-r @`.

## Usage

```
jj diff [OPTIONS] [FILESETS]...
```

## Arguments

- `[FILESETS]...` - Restrict the diff to these paths

## Options

```
-r, --revisions <REVSETS>   Show changes in these revisions
-f, --from <REVSET>         Show changes from this revision
-t, --to <REVSET>           Show changes to this revision
-h, --help                  Print help
```

## Diff Formatting Options

```
-T, --template <TEMPLATE>   Render each file diff entry using the given template
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
