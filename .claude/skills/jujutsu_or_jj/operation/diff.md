---
description: "jj operation diff - Compare changes to the repository between two operations"
---

# jj operation diff

Compare changes to the repository between two operations.

## Usage

```
jj operation diff [OPTIONS]
```

## Options

```
--operation <OPERATION>   Show repository changes in this operation [aliases: --op]

-f, --from <FROM>         Show repository changes from this operation

-t, --to <TO>             Show repository changes to this operation

--no-graph                Don't show the graph, show a flat list of modified changes

-p, --patch               Show patch of modifications to changes

-h, --help                Print help
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
--ignore-all-space          Ignore whitespace when comparing lines
--ignore-space-change       Ignore changes in amount of whitespace
```
